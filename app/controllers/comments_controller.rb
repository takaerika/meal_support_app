class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal_record
  before_action :require_supporter!

  def create
    # サポート関係にある患者の記録にだけコメント可
    unless linked_to_patient?(current_user, @meal_record.patient_id)
      redirect_to @meal_record, alert: "権限がありません" and return
    end

    @comment = @meal_record.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to @meal_record, notice: "コメントを投稿しました"
    else
      # show と同じレイアウトでエラーを表示したいので、show を再描画
      @record = @meal_record
      flash.now[:alert] = "コメントを投稿できませんでした"
      render "meal_records/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @meal_record.comments.find(params[:id])
    # 自分のコメントのみ削除可（必要なら）
    unless @comment.user_id == current_user.id
      redirect_to @meal_record, alert: "権限がありません" and return
    end
    @comment.destroy
    redirect_to @meal_record, notice: "コメントを削除しました"
  end

  private

  def set_meal_record
    @meal_record = MealRecord.find(params[:meal_record_id])
  end

  def require_supporter!
    redirect_to(root_path, alert: "サポーターのみ利用できます") unless current_user.supporter?
  end

  # Supporter と Patient の紐づけ判定（SupportLink を利用）
  def linked_to_patient?(supporter, patient_id)
    SupportLink.exists?(supporter_id: supporter.id, patient_id: patient_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
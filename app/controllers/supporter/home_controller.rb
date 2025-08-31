class Supporter::HomeController < Supporter::BaseController
  before_action :authenticate_user!
  before_action :require_supporter!

  def index
  sort  = params[:sort].presence || "recent"
  scope = current_user.patients

  @patients =
    case sort
    when "name"
      # ふりがながある人を優先して並べ、無い人は漢字でフォールバック
      scope.order(
        Arel.sql("CASE WHEN users.last_name_kana IS NULL OR users.last_name_kana = '' THEN 1 ELSE 0 END ASC"),
        :last_name_kana, :first_name_kana, :last_name, :first_name
      )
    when "recent"
      scope
        .left_joins(:meal_records)
        .select('users.*, MAX(meal_records.updated_at) AS last_meal_updated_at')
        .group('users.id')
        .order(Arel.sql('last_meal_updated_at IS NULL, last_meal_updated_at DESC'))
    else
      scope.order(:last_name, :first_name)
    end
   end
end
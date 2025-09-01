require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:patient)   { create(:user, role: :patient) }
  let(:supporter) { create(:user, role: :supporter) }
  let(:meal)      { create(:meal_record, patient: patient) }

  describe 'コメントの保存' do
    context '保存できる場合' do
      it '本文・サポーター・食事記録があれば保存できる' do
        comment = build(:comment, body: "よく噛んで食べられてますね！", user: supporter, meal_record: meal)
        expect(comment).to be_valid
      end

      it '本文が1000文字以内なら保存できる' do
        comment = build(:comment, body: "あ" * 1000, user: supporter, meal_record: meal)
        expect(comment).to be_valid
      end
    end

    context '保存できない場合' do
      it '本文が空では保存できない' do
        comment = build(:comment, body: "", user: supporter, meal_record: meal)
        comment.valid?
        expect(comment.errors.full_messages).to include("本文を入力してください")
      end

      it '本文が1001文字以上だと保存できない' do
        comment = build(:comment, body: "あ" * 1001, user: supporter, meal_record: meal)
        comment.valid?
        expect(comment.errors.full_messages).to include("本文は1000文字以内で入力してください")
      end

      it 'ユーザーが紐付いていなければ保存できない' do
        comment = build(:comment, body: "テスト", user: nil, meal_record: meal)
        comment.valid?
        expect(comment.errors.full_messages).to include("ユーザーを入力してください")
      end

      it '食事記録が紐付いていなければ保存できない' do
        comment = build(:comment, body: "テスト", user: supporter, meal_record: nil)
        comment.valid?
        expect(comment.errors.full_messages).to include("食事記録を入力してください")
      end
    end
  end
end
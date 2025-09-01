require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it '全ての必須項目が入力されていれば登録できる' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it '姓が空では登録できない' do
        user = build(:user, last_name: nil)
        user.valid?
        expect(user.errors.full_messages).to include("Last name can't be blank")
      end

      it '名が空では登録できない' do
        user = build(:user, first_name: nil)
        user.valid?
        expect(user.errors.full_messages).to include("First name can't be blank")
      end

      it 'メールアドレスが空では登録できない' do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors.full_messages).to include("Email can't be blank")
      end

      it 'メールアドレスが重複していると登録できない' do
        create(:user, email: "test@example.com")
        user = build(:user, email: "test@example.com")
        user.valid?
        expect(user.errors.full_messages).to include("Email has already been taken")
      end

      it 'パスワードが6文字未満では登録できない' do
        user = build(:user, password: '12345', password_confirmation: '12345')
        user.valid?
        expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
    end
  end
end


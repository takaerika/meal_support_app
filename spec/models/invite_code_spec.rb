require 'rails_helper'

RSpec.describe InviteCode, type: :model do
  describe '招待コードの発行' do
    context '正常に発行できる場合' do
      it 'サポーター登録時に自動で6桁のコードが生成される' do
        invite = create(:invite_code)
        expect(invite.code).to match(/\A[A-Z0-9]{6}\z/)
      end
    end

    context '発行できない場合' do
      it 'コードが重複していると登録できない' do
        create(:invite_code, code: 'ABC123')
        invite = build(:invite_code, code: 'ABC123')
        invite.valid?
        expect(invite.errors.full_messages).to include("Code has already been taken")
      end
    end
  end
end
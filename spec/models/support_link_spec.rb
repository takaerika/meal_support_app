require 'rails_helper'

RSpec.describe SupportLink, type: :model do
  describe '患者とサポーターの紐づけ' do
    context '紐づけできる場合' do
      it 'サポーターと患者があれば登録できる' do
        link = build(:support_link)
        expect(link).to be_valid
      end
    end

    context '紐づけできない場合' do
      it '同じ患者とサポーターの組み合わせは登録できない' do
        link = create(:support_link)
        dup  = build(:support_link, supporter: link.supporter, patient: link.patient)
        dup.valid?
        expect(dup.errors.full_messages).to include("Supporter has already been taken")
      end
    end
  end
end
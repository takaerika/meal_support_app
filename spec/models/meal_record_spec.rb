require 'rails_helper'

RSpec.describe MealRecord, type: :model do
  describe '食事記録の保存' do
    context '保存できる場合' do
      it '患者・日付・区分が揃っていれば保存できる' do
        record = build(:meal_record)
        expect(record).to be_valid
      end
    end

    context '保存できない場合' do
      it '日付が空だと保存できない' do
        record = build(:meal_record, eaten_on: nil)
        record.valid?
        expect(record.errors.full_messages).to include("Eaten on can't be blank")
      end

      it '区分が空だと保存できない' do
        record = build(:meal_record, slot: nil)
        record.valid?
        expect(record.errors.full_messages).to include("Slot can't be blank")
      end

      it '同じ日付・同じ区分は同一患者で重複登録できない' do
        rec1 = create(:meal_record, eaten_on: Date.current, slot: :breakfast)
        rec2 = build(:meal_record, patient: rec1.patient, eaten_on: rec1.eaten_on, slot: rec1.slot)
        rec2.valid?
        expect(rec2.errors.full_messages.join).to include("はこの区分ですでに登録されています")
      end
    end
  end
end
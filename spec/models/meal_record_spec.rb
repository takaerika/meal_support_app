require "rails_helper"

RSpec.describe MealRecord, type: :model do
  describe "食事記録の保存" do
    context "保存できる場合" do
      it "患者・日付・区分が揃い、テキストがあれば保存できる" do
        rec = build(:meal_record)
        expect(rec).to be_valid
      end

      it "テキストが空でも、JPEGがあれば保存できる" do
        rec = build(:meal_record, :no_text)
        rec.photo.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/sample.jpg")),
          filename: "sample.jpg",
          content_type: "image/jpeg"
        )
        expect(rec).to be_valid
      end

      it "テキストが空でも、PNGがあれば保存できる" do
        rec = build(:meal_record, :no_text)
        rec.photo.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/sample.png")),
          filename: "sample.png",
          content_type: "image/png"
        )
        expect(rec).to be_valid
      end
    end

    context "保存できない場合" do
      it "日付が空だと保存できない" do
        rec = build(:meal_record, eaten_on: nil)
        rec.valid?
        expect(rec.errors.full_messages).to include("Eaten on can't be blank")
      end

      it "区分が空だと保存できない" do
        rec = build(:meal_record, slot: nil)
        rec.valid?
        expect(rec.errors.full_messages).to include("Slot can't be blank")
      end

      it "同じ日付・同じ区分は同一患者で重複登録できない" do
        rec1 = create(:meal_record, eaten_on: Date.current, slot: :breakfast)
        rec2 = build(:meal_record, patient: rec1.patient, eaten_on: rec1.eaten_on, slot: rec1.slot)
        rec2.valid?
        expect(rec2.errors.full_messages.join).to include("はこの区分ですでに登録されています")
      end

      it "テキストも写真も無いと保存できない" do
        rec = build(:meal_record, text: "")
        rec.valid?
        expect(rec.errors.full_messages.join).to include("いずれかは必須")
      end

      it "GIFなど非対応形式だと保存できない" do
        rec = build(:meal_record, :no_text)
        rec.photo.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/sample.gif")),
          filename: "sample.gif",
          content_type: "image/gif"
        )
        rec.valid?
        expect(rec.errors[:photo]).to include("は JPG / PNG を選択してください")
      end

      it "5MB以上だと保存できない" do
      rec = build(:meal_record, :no_text)

      big = Tempfile.new(["big", ".jpg"])
      big.binmode
      big.seek(5.megabytes) 
      big.write("X")       
      big.rewind

      rec.photo.attach(io: big, filename: "big.jpg", content_type: "image/jpeg")
      rec.valid?

      expect(rec.errors[:photo]).to include("は5MB以下にしてください")
    ensure
     big.close!
      big.unlink
    end
    end
  end
end
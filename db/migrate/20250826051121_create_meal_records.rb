class CreateMealRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_records do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.date    :eaten_on,   null: false
      t.integer :slot,       null: false # 0:breakfast,1:lunch,2:dinner,3:snack
      t.text    :text
      t.text    :note

      t.timestamps
    end
    add_index :meal_records, [:patient_id, :eaten_on, :slot], unique: true, name: "index_meals_on_patient_date_slot"
  end
end


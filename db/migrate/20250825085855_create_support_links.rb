class CreateSupportLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :support_links do |t|
      t.references :supporter, null: false, foreign_key: { to_table: :users }  
      t.references :patient,   null: false, foreign_key: { to_table: :users }  

      t.timestamps
    end
    add_index :support_links, [:supporter_id, :patient_id], unique: true
  end
end
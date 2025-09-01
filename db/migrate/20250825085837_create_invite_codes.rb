class CreateInviteCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :invite_codes do |t|
      t.references :supporter, null: false, foreign_key: { to_table: :users }  
      t.string :code, null: false

      t.timestamps
    end
    add_index :invite_codes, :code, unique: true
  end
end

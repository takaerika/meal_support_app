class AddProfileAndRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string,  null: false
    add_column :users, :last_name,  :string,  null: false
    add_column :users, :role,       :integer, null: false, default: 0 # 0=patient,1=supporter
    add_column :users, :deleted_at, :datetime

    add_index :users, :role
    add_index :users, :deleted_at
  end
end
class AddLastMealUpdatedAtToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :last_meal_updated_at, :datetime
    add_index  :users, :last_meal_updated_at

    execute <<~SQL.squish
      UPDATE users u
      SET last_meal_updated_at = mr.max_updated_at
      FROM (
        SELECT patient_id AS user_id, MAX(updated_at) AS max_updated_at
        FROM meal_records
        GROUP BY patient_id
      ) mr
      WHERE mr.user_id = u.id
    SQL
  end

  def down
    remove_index  :users, :last_meal_updated_at
    remove_column :users, :last_meal_updated_at
  end
end
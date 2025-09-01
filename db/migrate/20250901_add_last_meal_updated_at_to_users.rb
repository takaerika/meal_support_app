class AddLastMealUpdatedAtToUsers < ActiveRecord::Migration[7.0]
  def up
    unless column_exists?(:users, :last_meal_updated_at)
      add_column :users, :last_meal_updated_at, :datetime
    end

    unless index_exists?(:users, :last_meal_updated_at, name: "index_users_on_last_meal_updated_at")
      add_index :users, :last_meal_updated_at, name: "index_users_on_last_meal_updated_at"
    end

    say_with_time "Backfilling users.last_meal_updated_at (DB-agnostic)" do
      User.reset_column_information
      User.find_in_batches(batch_size: 100) do |batch|
        ids = batch.map(&:id)
        rows = MealRecord.where(patient_id: ids).group(:patient_id).maximum(:updated_at)
        updates = rows.map { |(pid, ts)| [pid, ts] }.to_h
        next if updates.empty?
        existing = User.where(id: updates.keys).where.not(last_meal_updated_at: nil).pluck(:id)
        (updates.keys - existing).each do |pid|
          User.where(id: pid).update_all(last_meal_updated_at: updates[pid])
        end
      end
    end
  end

  def down
    if index_exists?(:users, :last_meal_updated_at, name: "index_users_on_last_meal_updated_at")
      remove_index :users, name: "index_users_on_last_meal_updated_at"
    end
    if column_exists?(:users, :last_meal_updated_at)
      remove_column :users, :last_meal_updated_at
    end
  end
end
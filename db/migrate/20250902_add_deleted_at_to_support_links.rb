class AddDeletedAtToSupportLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :support_links, :deleted_at, :datetime unless column_exists?(:support_links, :deleted_at)
    add_index  :support_links, :deleted_at   unless index_exists?(:support_links, :deleted_at)
  end
end
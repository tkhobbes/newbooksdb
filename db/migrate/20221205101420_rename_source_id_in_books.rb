class RenameSourceIdInBooks < ActiveRecord::Migration[7.0]
  def change
    rename_column :books, :source_id, :identifier
  end
end

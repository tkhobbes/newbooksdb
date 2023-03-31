class AddCoverSearchToBooks < ActiveRecord::Migration[7.0]
  def up
    add_column :books, :cover_searched, :boolean, default: false
    Book.all.each do |b|
      b.update(cover_searched: true)
    end
  end

  def down
    remove_column :books, :cover_searched
  end
end

class AddUniqueIndexToPerson < ActiveRecord::Migration
  def change
    add_index(:people, :article_title, :unique => true)
  end
end

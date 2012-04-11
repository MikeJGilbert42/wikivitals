class AddArticleTitleToPerson < ActiveRecord::Migration
  def change
    add_column :people, :article_title, :string
  end
end

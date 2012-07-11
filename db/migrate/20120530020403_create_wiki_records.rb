class CreateWikiRecords < ActiveRecord::Migration
  def change
    create_table :wiki_records do |t|
      t.string :article_title
      t.string :article_body

      t.timestamps
    end
  end
end

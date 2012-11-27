class CreatePageViews < ActiveRecord::Migration
  def change
    create_table :page_views do |t|
      t.integer :user_id
      t.integer :wiki_record_id

      t.timestamps
    end
  end
end

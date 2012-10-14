class AddIndexesToLinks < ActiveRecord::Migration
  def change
    add_index :links, :target_id
    add_index :links, :wiki_record_id
  end
end

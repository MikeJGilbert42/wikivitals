class AddRedirectIdToWikiRecord < ActiveRecord::Migration
  def change
    add_column :wiki_records, :redirect_id, :integer, :default => nil
  end
end

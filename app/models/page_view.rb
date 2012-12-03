class PageView < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki_record

  scope :recent, includes([:wiki_record, :user]).order("created_at DESC")

end

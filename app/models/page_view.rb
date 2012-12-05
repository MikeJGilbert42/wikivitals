class PageView < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki_record

  scope :recent, includes([:wiki_record, :user]).order("created_at DESC")

  def self.since page_view
    recent.where('created_at > ?', page_view.created_at)
  end
end

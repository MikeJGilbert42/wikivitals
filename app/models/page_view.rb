class PageView < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki_record
end

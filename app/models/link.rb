class Link < ActiveRecord::Base
  belongs_to :wiki_record, :foreign_key => :wiki_record_id, :class_name => 'WikiRecord'
  belongs_to :target, :foreign_key => :target_id, :class_name => 'WikiRecord'
end

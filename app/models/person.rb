class Person < ActiveRecord::Base
  attr_accessible :name, :death_date, :alive

  def self.get_fields
    accessible_attributes.to_a
  end

  def new_from_wiki_record record
    if !record.person?
      raise "This article is not of a person."
    end
    name = record["name"]
    death_date = record.death_date
    Person.create :name => name, :death_date => death_date
  end

  def alive?
    death_date.nil?
  end
end

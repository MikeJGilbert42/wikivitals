class Person < ActiveRecord::Base
  attr_accessible :name, :birth_date, :death_date, :alive, :article_title

  def self.get_fields
    accessible_attributes.to_a
  end

  def self.new_from_wiki_record record
    if !record.person?
      raise ArticleNotPerson "Not a person"
    end
    name = record[:name]
    birth_date = record.birth_date
    death_date = record.death_date
    article_title = record.article_title
    Person.create :name => name, :birth_date => birth_date, :death_date => death_date, :article_title => article_title, :alive => record.alive?
  end

  # Look up person from table based on assumed article name, and consult Wikipedia if no entry found
  def self.find_person article_title
    person = Person.where(:article_title => article_title).first
    if person.nil?
      begin
        article = WikiFetcher.get article_title
        person = new_from_wiki_record article
      rescue Exceptions::ArticleNotFound => e
        raise e
      end
    end
    person
  end

end

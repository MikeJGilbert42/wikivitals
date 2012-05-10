class Person < ActiveRecord::Base
  validates_uniqueness_of :article_title

  def self.new_from_wiki_record record
    if !record.person?
      raise Exceptions::ArticleNotPerson.new "Not a person"
    end
    name = record[:name]
    birth_date = record.birth_date
    death_date = record.death_date
    article_title = record.article_title
    Person.create :name => name, :birth_date => birth_date, :death_date => death_date, :article_title => article_title, :alive => record.alive?
  end

  # Look up person from table based on assumed article name, and consult Wikipedia if no entry found
  def self.find_person article_title
    article_title = WikiHelper::repair_link article_title
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

class Person < ActiveRecord::Base
  include WikiHelper
  validates_uniqueness_of :article_title

  # Look up person from table based on assumed article name, and consult WikiRecord if no entry found
  def self.find_person article_title
    article_title = repair_link article_title
    person = Person.where(:article_title => article_title).first
    if person.nil?
      begin
        article = WikiRecord.fetch article_title
        person = new_from_wiki_record article
      rescue Exceptions::ArticleNotFound => e
        raise e
      end
    end
    person
  end

  # Find the Person corresponding to this record or create it if not found.
  def self.get_person_for_wiki_record record
    find_person record.article_title
  end

  private

  def self.new_from_wiki_record record
    if !record.person?
      raise Exceptions::ArticleNotPerson.new "Not a person"
    end
    name = record.infohash(:name)
    birth_date = record.birth_date
    death_date = record.death_date
    article_title = record.article_title
    Person.create :name => name, :birth_date => birth_date, :death_date => death_date, :article_title => article_title, :alive => record.alive?
  end
end

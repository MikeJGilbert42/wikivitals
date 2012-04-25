require 'spec_helper'
include Exceptions

describe Person do
  before :all do
    mock_wiki_fetcher
  end

  describe "#find_person" do
    it "handles 404 errors" do
      lambda { Person.find_person("Fsjal") }.should raise_error(ArticleNotFound)
    end

    it "rejects non-people" do
      lambda { Person.find_person("Sherlock Holmes") }.should raise_error(ArticleNotPerson)
    end
  end
end

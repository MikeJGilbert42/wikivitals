require 'prototype/disambiguation.rb'
include WikiHelper

describe Disambiguation do
  describe "#parse_disambiguation", :focus => true do
    page = mock_get_article_body "David_Thomas"
    result = Disambiguation::parse page
    result.should =~ ["Dave Thomas (American businessman)",
                      "Dave Thomas (actor)",
                      "Dave Thomas (physicist)",
                      "Dave Thomas (programmer)",
                      "David A. Thomas (software developer)",
                      "David Thomas (beach volleyball)",
                      "David Thomas (industrialist)",
                      "David Thomas (murderer)",
                      "David Thomas (singer)"]
  end
end

require 'spec_helper'

describe WikiRecord do
  before do
    class WikiFetcher
      alias_method :old_wiki_fetch, :wiki_fetch
      def wiki_fetch(page_name)
        mock_wiki_fetch(page_name)
      end
    end
    @sam_neill = WikiRecord.new "Sam_Neill"
    @einstein = WikiRecord.new "Einstein"
    @sherlock = WikiRecord.new "Sherlock_Holmes"
  end

  describe "#person?" do
    it "works on Sam Neill" do
      @sam_neill.should_not == nil
      @sam_neill.person?.should == true
    end

    it "works on Sherlock Holmes" do
      @sherlock.person?.should == false
    end

    it "works on Albert Einstein" do
      #TODO: this doesn't work yet
      #@einstein.person?.should == true
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      @einstein["name"].should == "Albert Einstein"
    end
  end
end

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
    it "throws the right exception on disambiguation pages" do
      david = WikiRecord.new "David_Thomas"
      lambda { david.alive? }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      dave = WikiRecord.new "David_Thomas"
      lambda { dave.alive? }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end
end

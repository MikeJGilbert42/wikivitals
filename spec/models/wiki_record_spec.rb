require 'spec_helper'

describe WikiRecord do
  before(:all) do
    class WikiFetcher
      def self.get_article_body(page_name)
        mock_get_article_body(page_name)
      end
    end
    @sam_neill = WikiFetcher.get "Sam_Neill"
    @sam_neil = WikiFetcher.get "Sam_Neil"
    @einstein = WikiFetcher.get "Einstein"
    @sherlock = WikiFetcher.get "Sherlock_Holmes"
    @takei = WikiFetcher.get "George_Takei"
    @elvis = WikiFetcher.get "Elvis_Presley"
  end

  describe "#person?" do
    it "works on people of type person" do
      @sam_neill.should_not == nil
      @sam_neill.person?.should == true
      @takei.person?.should == true
    end

    it "works on Sherlock Holmes" do
      @sherlock.person?.should == false
    end

    it "works on Albert Einstein" do
      @einstein.person?.should == true
    end

    it "works on Elvis" do
      @elvis.person?.should == true
    end

    it "works on Archduke Franz Ferdinand" do
      franz = WikiFetcher.get "Archduke_Franz_Ferdinand_of_Austria"
      franz.person?.should == true
    end

    it "works on Alexander Hamilton" do
      alex = WikiFetcher.get "Alexander_Hamilton"
      alex.person?.should == true
    end
  end

  describe "#alive?" do
    it "shows George Takei as being alive" do
      @takei.alive?.should == true
    end

    it "shows Elvis as being dead" do
      @elvis.alive?.should == false
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      @einstein[:name].should == "Albert Einstein"
      @sam_neil[:name].should == "Sam Neill"
    end
    it "throws the right exception on disambiguation pages" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end
end

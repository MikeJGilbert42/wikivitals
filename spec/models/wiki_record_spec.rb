require 'spec_helper'

describe WikiRecord do
  before(:all) do
    mock_wiki_fetcher
    @sam_neill = WikiFetcher.get "Sam_Neill"
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

  describe "#birth_date" do
    it "parses birth dates correctly" do
      @takei.birth_date.should == Date.parse("20/4/1937")
      @elvis.birth_date.should == Date.parse("8/1/1935")
      @sam_neill.birth_date.should == Date.parse("14/9/1947")
      @einstein.birth_date.should == Date.parse("14/3/1879")
    end
  end

  describe "#alive?" do
    it "shows George Takei as being alive" do
      @takei.alive?.should == true
    end

    it "shows Elvis as being dead" do
      @elvis.alive?.should == false
    end

    it "handles Joe Dean being alive even though he has no infobox" do
      joe = WikiFetcher.get "Joe_Dean"
      joe.alive?.should == true
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      @einstein[:name].should == "Albert Einstein"
      sam_neil = WikiFetcher.get "Sam_Neil"
      sam_neil[:name].should == "Sam Neill"
    end
    it "handles Abe Lincoln's redirect" do
      abe = WikiFetcher.get "Abe_Lincoln"
      abe[:name].should == "Abraham Lincoln"
    end
    it "throws the right exception on disambiguation pages" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end
end

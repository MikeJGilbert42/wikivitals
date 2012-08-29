require 'spec_helper'

describe WikiRecord do
  before(:all) do
    mock_wiki_fetcher
  end

  describe "#redirect" do
    it "has an activerecord redirect association" do
      # Disable reading article
      WikiRecord.any_instance.stub(:read_article).and_return nil
      source = WikiRecord.create :article_title => "Source", :article_body => nil
      destination = WikiRecord.create :article_title => "Destination", :article_body => nil
      source.redirect = destination
      source.save!
      WikiRecord.where(:article_title => "Source").first.redirect.article_title.should == "Destination"
    end
  end

  describe "reading an article" do
    before(:all) do
      @sam_neill = WikiFetcher.get "Sam_Neill"
      @sherlock = WikiFetcher.get "Sherlock_Holmes"
      @takei = WikiFetcher.get "George_Takei"
      @elvis = WikiFetcher.get "Elvis_Presley"
      @einstein = WikiFetcher.get "Albert_Einstein"
    end
    describe "#person?" do
      it "works on people of type person" do
        @sam_neill.should_not == nil
        @sam_neill.person?.should == true
        @takei.person?.should == true
      end

      it "works on Sherlock Holmes" do
        @sherlock.should_not == nil
        @sherlock.person?.should == false
      end

      it "works on Elvis" do
        @elvis.should_not == nil
        @elvis.person?.should == true
      end
    end
    describe "#birth_date" do
      it "parses birth dates correctly" do
        @takei.should_not == nil
        @elvis.should_not == nil
        @sam_neill.should_not == nil
        @einstein.should_not == nil
        @takei.birth_date.should == Date.parse("20/4/1937")
        @elvis.birth_date.should == Date.parse("8/1/1935")
        @sam_neill.birth_date.should == Date.parse("14/9/1947")
        @einstein.birth_date.should == Date.parse("14/3/1879")
      end
    end

    describe "#alive?" do
      it "shows George Takei as being alive" do
        @takei.should_not == nil
        @takei.alive?.should == true
      end

      it "shows Elvis as being dead" do
        @elvis.should_not == nil
        @elvis.alive?.should == false
      end

      it "handles Joe Dean being alive even though he has no infobox" do
        joe = WikiFetcher.get "Joe_Dean"
        joe.alive?.should == true
      end
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      einstein = WikiFetcher.get "Einstein"
      einstein.infohash(:name).should == "Albert Einstein"
      sam_neil = WikiFetcher.get "Sam_Neil"
      sam_neil.infohash(:name).should == "Sam Neill"
    end
    it "handles Abe Lincoln's redirect" do
      abraham = WikiFetcher.get "Abe_Lincoln"
      abraham.infohash(:name).should == "Abraham Lincoln"
      abe = WikiRecord.where(:article_title => "Abe_Lincoln").first
      abe.should be
      abe.redirect.should == abraham
    end
    it "throws the right exception on disambiguation pages" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      lambda { WikiFetcher.get "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end

  describe "#find" do
    it "works on Archduke Franz Ferdinand" do
      franz = WikiFetcher.get "Archduke_Franz_Ferdinand_of_Austria"
      franz.person?.should == true
    end

    it "works on Alexander Hamilton" do
      alex = WikiFetcher.get "Alexander_Hamilton"
      alex.person?.should == true
    end

    it "should only fetch the Wikipedia article once" do
      WikiFetcher.get "Alexander_Hamilton"
      WikiFetcher.should_receive(:get_article_body).exactly(0).times
      WikiFetcher.get "Alexander_Hamilton"
    end
  end
end

require 'spec_helper'

describe WikiRecord do
  before(:all) do
    mock_wiki_fetcher
  end

  describe "#redirect" do
    it "saves the redirected wiki_record in the database" do
      WikiRecord.fetch "Einstein"
      WikiRecord.where(:article_title => "Einstein").should be
      WikiRecord.should_receive(:get_article_body).exactly(0).times
      WikiRecord.fetch "Einstein"
    end
    it "saves redirects in the links join table" do
      WikiRecord.fetch "Einstein"
      source = WikiRecord.where(article_title: "Einstein").first
      destination = WikiRecord.where(article_title: "Albert_Einstein").first
      source.targets.first.should == destination
      source.targets.count.should == 1
      source.links.count.should == 1
    end
    it "handles double redirects" do
      WikiRecord.fetch "Einstine" # fake article ...
      WikiRecord.all.count.should == 3
      one = WikiRecord.where(article_title: "Einstine").first
      two = WikiRecord.where(article_title: "Einstein").first
      three = WikiRecord.where(article_title: "Albert_Einstein").first
      [one, two, three].map(&:targets).map(&:count).should == [1, 1, 0]
    end
  end

  describe "reading an article" do
    before(:all) do
      let sam_neill = WikiRecord.fetch "Sam_Neill"
      @sherlock = WikiRecord.fetch "Sherlock_Holmes"
      @takei = WikiRecord.fetch "George_Takei"
      @elvis = WikiRecord.fetch "Elvis_Presley"
      @einstein = WikiRecord.fetch "Albert_Einstein"
    end
    describe "#person?" do
      it "works on people of type person" do
        @sam_neill.should be
        @sam_neill.person?.should be_true
        @takei.person?.should be_true
      end

      it "works on Sherlock Holmes" do
        @sherlock.should be
        @sherlock.person?.should be_false
      end

      it "works on Elvis" do
        @elvis.should be
        @elvis.person?.should be_true
      end
    end
    describe "#birth_date" do
      it "parses birth dates correctly" do
        @takei.should be
        @elvis.should be
        @sam_neill.should be
        @einstein.should be
        @takei.birth_date.should == Date.parse("20/4/1937")
        @elvis.birth_date.should == Date.parse("8/1/1935")
        @sam_neill.birth_date.should == Date.parse("14/9/1947")
        @einstein.birth_date.should == Date.parse("14/3/1879")
      end
    end

    describe "#alive?" do
      it "shows George Takei as being alive" do
        @takei.should be
        @takei.alive?.should be_true
      end

      it "shows Elvis as being dead" do
        @elvis.should be
        @elvis.alive?.should be_false
      end

      it "handles Joe Dean being alive even though he has no infobox" do
        joe = WikiRecord.fetch "Joe_Dean"
        joe.alive?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      einstein = WikiRecord.fetch "Einstein"
      einstein.infohash(:name).should == "Albert Einstein"
      sam_neil = WikiRecord.fetch "Sam_Neil"
      sam_neil.infohash(:name).should == "Sam Neill"
    end
    it "handles Abe Lincoln's redirect" do
      abraham = WikiRecord.fetch "Abe_Lincoln"
      abraham.infohash(:name).should == "Abraham Lincoln"
      abe = WikiRecord.where(:article_title => "Abe_Lincoln").first
      abe.should be
      abe.redirect.should == abraham
    end
    it "throws the right exception on disambiguation pages" do
      lambda { WikiRecord.fetch "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      lambda { WikiRecord.fetch "David_Thomas" }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end

  describe "#find" do
    it "works on Archduke Franz Ferdinand" do
      franz = WikiRecord.fetch "Archduke_Franz_Ferdinand_of_Austria"
      franz.person?.should be_true
    end

    it "works on Alexander Hamilton" do
      alex = WikiRecord.fetch "Alexander_Hamilton"
      alex.person?.should be_true
    end

    it "should only fetch the Wikipedia article once" do
      WikiRecord.fetch "Alexander_Hamilton"
      WikiFetcher.should_receive(:get_article_body).exactly(0).times
      WikiRecord.fetch "Alexander_Hamilton"
    end
  end
end

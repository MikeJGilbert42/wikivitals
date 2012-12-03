require 'spec_helper'

describe WikiRecord do
  before(:all) do
    mock_wiki_fetcher
  end

  describe ".redirect" do
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
      lambda { WikiRecord.fetch "Einstine" }.should change { WikiRecord.all.count }.by(3)
      [WikiRecord.where(article_title: "Einstine").first,
       WikiRecord.where(article_title: "Einstein").first,
       WikiRecord.where(article_title: "Albert_Einstein").first
      ].map(&:targets).map(&:count).should == [1, 1, 0]
    end
  end

  describe "reading article bodies better" do
    subject { WikiRecord.fetch article_name }
    describe "Basic vitals" do
      context "Sam Neill" do
        let(:article_name) { "Sam_Neill" }
        it { should be }
        it { should be_person }
        its(:birth_date) { should == Date.parse("14/9/1947") }
      end
      context "Sherlock Holmes" do
        let(:article_name) { "Sherlock_Holmes" }
        it { should_not be_person }
      end
      context "Elvis" do
        let(:article_name) { "Elvis_Presley" }
        it { should be_person }
        it { should_not be_alive }
        its(:birth_date) { should == Date.parse("8/1/1935") }
      end
      context "George Takei" do
        let(:article_name) { "George_Takei" }
        its(:birth_date) { should == Date.parse("20/4/1937") }
        it { should be_alive }
      end
      context "Albert Einstein" do
        let(:article_name) { "Albert_Einstein" }
        its(:birth_date) { should == Date.parse("14/3/1879") }
      end
      context "a living person with no infobox" do
        let(:article_name) { "Joe_Dean" }
        it { should be_alive }
      end
      context "naming a person with no infobox" do
        let(:article_name) { "John_Smith_(explorer)" }
        its(:name) { should == "John Smith" }
      end
      context "people with HTML in their names" do
        let(:article_name) { "Elton_John" }
        its(:name) { should_not =~ /<br \/>/ }
        its(:name) { should_not =~ /\[\[[^\]]*\]\]/ }
      end
      context "ancient dead people" do
        context "Socrates" do
          let(:article_name) { "Socrates" }
          it { should_not be_alive }
        end
        context "Ptolemy" do
          let(:article_name) { "Ptolemy" }
          it { should_not be_alive }
          its(:death_date) { should == Date.parse("1/1/0168") }
        end
        context "Hippocrates" do
          let(:article_name) { "Hippocrates" }
          it { should_not be_alive }
        end
        context "Pindar" do
          let(:article_name) { "Pindar" }
          it { should_not be_alive }
        end
      end
      context "Beach volleyball player David Thomas" do
        let(:article_name) { "David_Thomas_(beach_volleyball)" }
        it { should be_person }
      end
    end
  end

  describe "#fetch" do
    it "handles redirects" do
      einstein = WikiRecord.fetch "Einstein"
      einstein.article_title.should == "Albert_Einstein"
      sam_neil = WikiRecord.fetch "Sam_Neil"
      sam_neil.article_title.should == "Sam_Neill"
    end

    it "handles Abe Lincoln's redirect" do
      abraham = WikiRecord.fetch "Abe_Lincoln"
      abraham.infohash(:name).should == "Abraham Lincoln"
      abe = WikiRecord.where(:article_title => "Abe_Lincoln").first
      abe.should be
      abe.redirect.should == abraham
      abe2 = WikiRecord.fetch "Abe_Lincoln", :follow_redirects => false
      abe2.should == abe
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

  describe "disambiguations" do
    subject { WikiRecord.fetch article_name }
    describe "processing" do
      context "David Thomas disambiguation page" do
        let(:article_name) { "David_Thomas" }
        it { should be_disambiguation }
        it { should have(8).targets }
      end
      context "Jack White disambiguation page" do
        let(:article_name) { "John_White" }
        it { should be_disambiguation }
      end
    end
  end

  describe "not-found handling" do
    it "searches normal and fixed urls before erroring out" do
      WikiFetcher.should_receive(:get_article_body).once.with("not_the_article").and_raise(Exceptions::ArticleNotFound)
      WikiFetcher.should_receive(:get_article_body).once.with("Not_the_Article").and_raise(Exceptions::ArticleNotFound)
      lambda { WikiRecord.fetch "not_the_article" }.should raise_error(Exceptions::ArticleNotFound)
    end
  end
end

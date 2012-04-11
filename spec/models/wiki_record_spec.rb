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
    @sam_neil = WikiRecord.new "Sam_Neil"
    @einstein = WikiRecord.new "Einstein"
    @sherlock = WikiRecord.new "Sherlock_Holmes"
    @takei = WikiRecord.new "George_Takei"
    @elvis = WikiRecord.new "Elvis_Presley"
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
      franz = WikiRecord.new "Archduke_Franz_Ferdinand_of_Austria"
      franz.person?.should == true
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
      david = WikiRecord.new "David_Thomas"
      lambda { david.alive? }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
    it "repairs redirects when the link is named improperly ([[David Thomas]] instead of [[David_Thomas]])" do
      dave = WikiRecord.new "David_Thomas"
      lambda { dave.alive? }.should raise_error(RuntimeError, "You're gonna have to be more specific.")
    end
  end
end

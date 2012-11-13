require 'spec_helper'

describe WikiRecordsController do

  let(:barack) { Person.find_person("Barack_Obama") }
  before(:all) do
    mock_wiki_fetcher
  end

  describe "GET search" do
    before :each do
      get :search, :q => query_string
    end
    context "with a query yielding a unique result" do
      let(:query_string) { "Barack Obama" }
      it "redirects to the show Person page" do
        response.should redirect_to barack
      end
    end
    context "with a query yielding a disambiguation page" do
      let(:query_string) { "Dave Thomas" }
      it "renders the disambiguate template" do
        response.should redirect_to :action => 'disambiguate', :page => 'David_Thomas'
      end
      it "sets the @result instance variable" do
        assigns(:result).should_not be_nil
        assigns(:result).targets.count.should == 8
      end
    end
  end

  describe "GET index" do
    before do
      get :index
    end
    it "renders successfully" do
      response.should render_template("index")
    end
  end
end

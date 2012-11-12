require 'spec_helper'

describe SearchController do
  before(:all) do
    mock_wiki_fetcher
  end

  describe "GET search" do
    before :each do
      get :search, :q => query_string
    end
    context "with a query yielding a unique result" do
      let(:query_string) { "Barack Obama" }
      it "renders the show template" do
        response.should render_template("show")
      end
      it "sets the @people instance variable" do
        assigns(:people).should_not be_nil
      end
    end
    context "with a query yielding a disambiguation page" do
      let(:query_string) { "Dave Thomas" }
      it "renders the disambiguate template" do
        response.should redirect_to :action => 'disambiguate', :page => 'David_Thomas'
      end
      it "sets the @people instance variable" do
        assigns(:people).should_not be_nil
        assigns(:people).count.should == 8
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

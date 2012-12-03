require 'spec_helper'

describe WikiRecordsController do

  let(:barack) { Person.find_person("Barack_Obama") }
  before(:all) do
    mock_wiki_fetcher
  end

  describe "GET search" do
    before :each do
      create_current_user
      get :search, :q => query_string
    end
    context "with a query yielding a unique result" do
      let(:query_string) { "Barack Obama" }
      it "redirects to the show Person page" do
        response.should render_template :show
      end
      it "sets the user_id cookie" do
        cookies.signed[:user_id].should be
      end
      it "adds a pageview for the current user" do
        assigns[:user].page_views.count.should == 1
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

  describe "GET details" do
    describe "html response" do
      before do
        get :details, :article_title => 'Barack Obama', :format => :html
      end
      it "formats the details partial" do
        response.should render_template "_details"
      end
    end
  end
end

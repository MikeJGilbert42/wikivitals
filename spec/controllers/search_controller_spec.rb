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
    end
    context "with a query yielding a disambiguation page" do
      let(:query_string) { "Dave Thomas" }
      it "renders the disambiguate template" do
        response.should redirect_to :controller => 'search', :action => 'disambiguate', :page => 'David_Thomas'
      end
    end
  end
end

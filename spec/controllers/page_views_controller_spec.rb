require 'spec_helper'

describe PageViewsController, :focus => true do
  render_views

  let (:user1) { FactoryGirl.create :user }
  let (:user2) { FactoryGirl.create :user }
  before do
    5.times do
      FactoryGirl.create :page_view, :user => user1
      FactoryGirl.create :page_view, :user => user2
    end
  end
  describe "Get recent (JSON)" do
    before do
      get :recent, :format => 'JSON'
    end
    it "returns a parsable JSON array of recent page views" do
      expect { JSON.parse(response.body) }.to_not raise_error
    end
    it "contains the data we expect" do
      hash = JSON.parse response.body
      hash["page-views"].first.should have_key "color"
      hash["page-views"].first.should have_key "record"
      hash["page-views"].first.should have_key "name"
    end
  end

  describe "Get since (JSON)" do
    before do
      get :since, :format => 'JSON', :id => 5
    end
    it "returns only the newest 5 page views" do
      JSON.parse(response.body)["page-views"].map { |view| view["page-view-id"].to_i }.each do |x|
        x.should > 5
      end
      binding.pry
    end
  end
end

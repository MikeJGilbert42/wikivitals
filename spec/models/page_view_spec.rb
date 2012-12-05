require 'spec_helper'

describe PageView do
  let (:user1) { FactoryGirl.create :user }
  let (:user2) { FactoryGirl.create :user }

  describe "#recent scope" do
    context "With 10 view entries alternating between users" do
      before do
        5.times do
          FactoryGirl.create :page_view, :user => user1
          FactoryGirl.create :page_view, :user => user2
        end
      end
      it "should have 10 history entries" do
        PageView.recent.count.should == 10
      end
      it "should have 5 views that belong to user1" do
        PageView.recent.where("user_id=?", user1.id).count.should == 5
      end
      it "should have 5 views that belong to user2" do
        PageView.recent.where("user_id=?", user2.id).count.should == 5
      end
      it "should sort the page views correctly" do
        PageView.recent[0].user.should == user2
        PageView.recent[1].user.should == user1
      end
      it "should be limitable" do
        PageView.recent.limit(5).count.should == 5
      end
      it "should be scopable to entries newer than provided" do
        last = PageView.recent[3]
        PageView.since(last).map(&:id).should == PageView.recent[0..2].map(&:id)
      end
    end
  end
end


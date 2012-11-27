require 'spec_helper'

describe User do
  it "should have a color" do
    subject.save
    subject.color.should_not == nil
  end
end

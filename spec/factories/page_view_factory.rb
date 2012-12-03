FactoryGirl.define do
  factory :page_view do
    association :user
    association :wiki_record
  end
end

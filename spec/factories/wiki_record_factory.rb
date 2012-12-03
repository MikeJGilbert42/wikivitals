FactoryGirl.define do
  sequence (:article_title) { |n| "John_Poe_#{n}" }

  factory :wiki_record do
    article_title
  end
end


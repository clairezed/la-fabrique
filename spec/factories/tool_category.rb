FactoryGirl.define do
  factory :tool_category, class: ToolCategory do 
    sequence(:title) {|n| "Cat #{n}"}
  end
end
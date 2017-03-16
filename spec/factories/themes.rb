FactoryGirl.define do
  factory :theme, class: Theme do 
    sequence(:title) {|n| "Theme #{n}"}
  end
end
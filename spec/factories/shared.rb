FactoryGirl.define do

  trait :pending do
    state "pending"
  end

  trait :accepted do
    state "accepted"
  end

  trait :rejected do
    state "rejected"
  end

end
FactoryGirl.define do
  factory :user do
    name     "Matt Case"
    email    "matt@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
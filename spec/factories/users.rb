FactoryGirl.define do
  sequence :email do |n|
    "user_#{n}@test.com"
  end

  factory :user do
    user
    password '12345678'
    password_conformaation '12345678'
  end
end

FactoryBot.define do
  factory :user do
    user_name { "test_01" }
    email { "testmail01@test.co.jp" }
    password { "password" }
  end
end

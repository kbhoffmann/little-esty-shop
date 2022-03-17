FactoryBot.define do
  factory :user do
    username { "MyString" }
    password_digest { "MyString" }
    role { 1 }
  end
end

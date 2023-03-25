FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory(:project) do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    hyper_params {{"k_value"=>"6"}}

    association :user
  end
end
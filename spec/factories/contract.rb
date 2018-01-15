FactoryBot.define do
  factory :contract do
    user
    vendor "Deutsche Bahn"
    starts_on Time.current.utc
    ends_on 1.year.from_now.utc
    price 783.99
  end
end

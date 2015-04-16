
FactoryGirl.define do
  factory :category, :class => Refinery::Videos::Category do
    sequence(:name) { |n| "refinery#{n}" }
  end
end


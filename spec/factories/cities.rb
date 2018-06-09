FactoryGirl.define do
  factory :city do
    title  {FFaker::Address.city}
    region
    factory :city_with_campus do
      campus {build_list :campu,2}
    end
  end
end

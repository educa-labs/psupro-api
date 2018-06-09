FactoryGirl.define do
  factory :region do
    title {FFaker::AddressDA.region}
    country
    factory :region_with_cities do
      cities {build_list :city,2}
    end
  end
end

FactoryGirl.define do
  factory :country do
    title {FFaker::Address.country}
    factory :country_with_regions do
      regions {build_list :region,3}
    end
  end
end

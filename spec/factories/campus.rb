FactoryGirl.define do
  factory :campu do
    title {FFaker::Name.male_name_with_prefix_suffix}
    university
    lat {FFaker::Geolocation.lat}
    long {FFaker::Geolocation.lng}
    address {FFaker::Address.street_address}
    city
    factory :campu_with_carreers do
      carreers {build_list :carreer,2}
    end
  end
end

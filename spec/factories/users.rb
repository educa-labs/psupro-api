FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    phone "+56912345678"
    birth_date {FFaker::Time.date}
    first_name {FFaker::Name.first_name}
    last_name {FFaker::Name.last_name}
    city
    admin false
    institution
    level
    rut "30.686.957-4"
    password "jajasaludos"
    password_confirmation "jajasaludos"
  end
end

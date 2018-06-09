FactoryGirl.define do
  factory :carreer do
    title {FFaker::Education.degree}
    university
    campu
    certification 1
    semesters 7
    price 1000000
    area {FFaker::Education.major}
    schedule "day"
    openings 100
    employability 1.0
    income 1000
  end
end

FactoryGirl.define do
  factory :university do
    foundation {FFaker::Time.date }
    website {FFaker::Internet.http_url}
    freeness false
    motto {FFaker::Lorem.phrase}
    nick {FFaker::NameTHEN.nick_name}
    institution
    factory :university_with_campus do
      campus {build_list :campu, 2}
    end
  end
end

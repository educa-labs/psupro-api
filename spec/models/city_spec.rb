require 'rails_helper'

RSpec.describe City, type: :model do
  before {@city = FactoryGirl.build(:city_with_campus)}
  subject{@city}

  it {should respond_to :title}
  it {should respond_to :region}
  it {should respond_to :campus}
end

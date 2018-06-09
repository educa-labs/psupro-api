require 'rails_helper'

RSpec.describe Region, type: :model do
  before {@region = FactoryGirl.build(:region_with_cities)}
  subject{@region}

  it {should respond_to :title}
  it {should respond_to :cities}
  it {should respond_to :country}
end

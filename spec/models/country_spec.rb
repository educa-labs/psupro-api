require 'rails_helper'


RSpec.describe Country, type: :model do
  before {@country =FactoryGirl.build :country_with_regions}
  subject{@country}

  it {should respond_to :title}
  it {should respond_to :regions}
  it {should validate_uniqueness_of :title}
end

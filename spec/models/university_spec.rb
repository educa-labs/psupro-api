require 'rails_helper'

RSpec.describe University, type: :model do
  before {@university = FactoryGirl.build(:university_with_campus)}
  subject{@university}



  it {should respond_to :foundation}
  it {should respond_to :motto}
  it {should respond_to :website}
  it {should respond_to :nick}
  it {should respond_to :institution}
end

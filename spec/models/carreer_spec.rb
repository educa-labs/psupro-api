require 'rails_helper'

RSpec.describe Carreer, type: :model do
  before {@carreer = FactoryGirl.build(:carreer)}
  subject{@carreer}

  it {should respond_to :title}
  it {should respond_to :university}
  it {should respond_to :campu}
  it {should respond_to :certification}
  it {should respond_to :semesters}
  it {should respond_to :price}
  it {should respond_to :area}
  it {should respond_to :schedule}
  it {should respond_to :openings}
  it {should respond_to :employability}
  it {should respond_to :income}
end

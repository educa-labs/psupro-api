require 'rails_helper'

RSpec.describe Campu, type: :model do
  before {@campu = FactoryGirl.build(:campu_with_carreers)}
  subject{@campu}



  it {should respond_to :title}
  it {should respond_to :university}
  it {should respond_to :lat}
  it {should respond_to :long}
  it {should respond_to :address}
  it {should respond_to :city}
  it {should respond_to :carreers}

end

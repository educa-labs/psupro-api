class User < ApplicationRecord
  include ActiveModel::Validations
  validates :auth_token, uniqueness: true
  validates_presence_of :first_name,:last_name,:email
  validates :nem, allow_blank:true, numericality: {less_than_or_equal_to: 826, greater_than_or_equal_to: 208}
  validates :ranking, allow_blank:true, numericality: {less_than_or_equal_to: 850, greater_than_or_equal_to: 200}
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable # Devise utilities.
  before_create :generate_authentication_token! # Generates auth token.

  has_and_belongs_to_many :carreers
  has_many :essays
  has_many :objectives
  has_many :recommendations

  # Creates unique auth token.
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
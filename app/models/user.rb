class User < ApplicationRecord

  has_secure_password

  has_many :incomes
  has_many :expenses
  has_many :debts
  has_many :assets
  has_many :credits

  validates :name, :username, :password, presence: true
  validates :username, uniqueness: true

  include UsersHelper

  attr_accessor :future_net_worth

  def to_s
    self.name
  end

end

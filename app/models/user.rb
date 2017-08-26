class User < ApplicationRecord

  has_secure_password

  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :assets, dependent: :destroy

  validates :name, :username, :password, presence: true
  validates :username, uniqueness: true

  include UsersHelper

  attr_accessor :future_net_worth

  def to_s
    self.name
  end

end

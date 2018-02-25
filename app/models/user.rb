class User < ApplicationRecord

  has_secure_password

  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :transfers, dependent: :destroy

  validates :first_name, :last_name, :email, :password, presence: true
  email_regex = /\A[\w+\-.]+@[a-zA-Z\d\-]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 2, maximum: 255}, format: {with: email_regex}

  include UsersHelper

  attr_accessor :future_net_worth

  def to_s
    self.full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end

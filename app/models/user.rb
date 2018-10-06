class User < ApplicationRecord

  has_secure_password

  has_many :incomes, dependent: :destroy # dependent: :destroy makes sure all user's incomes are deleted if user is deleted
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

  def total_assets
    assets.map{|a| a.amount}.inject(0){|sum,x| sum + x }
  end

  def liquid_assets
    assets.map{|a| a.amount if a.liquid}.compact.inject(0){|sum,x| sum + x }
  end

  def total_debts
    debts.map{|d| d.amount}.inject(0){|sum,x| sum + x }
  end

  def total_net_worth
    number_to_currency(total_assets-total_debts)
  end

  def liquid_net_worth
    number_to_currency(liquid_assets-total_debts)
  end

  def future_net_worth(date)

  end

  def future_asset_value(date)

  end

  def future_debt_value(date)

  end

  def future_single_asset_value(date)
    
  end

  def future_single_debt_value(date)

  end

end

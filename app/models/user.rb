class User < ApplicationRecord

  has_secure_password

  has_many :incomes, dependent: :destroy # dependent: :destroy makes sure all user's incomes are deleted if user is deleted
  has_many :expenses, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :transfers, dependent: :destroy

  validates :first_name, :last_name, :email, :birthday, presence: true
  email_regex = /\A[\w+\-.]+@[a-zA-Z\d\-]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 2, maximum: 255}, format: {with: email_regex}
  validates :password, presence: true, length: {minimum: 6}, allow_blank: true

  include UsersHelper

  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
  before_save :downcase_email

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def downcase_email
    self.email.downcase!
  end

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

  private

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

end

class User < ApplicationRecord

  has_secure_password

  has_many :expenses
  has_many :liabilities
  has_many :liquid_assets
  has_many :non_liquid_assets
  has_many :people

  validates :name, :username, :password, presence: true

  def to_s
    self.name
  end

end

class Asset < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :liquid, :presence => true

end

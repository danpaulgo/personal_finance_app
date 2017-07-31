class Income < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :frequency, :user_id, :presence => true

end

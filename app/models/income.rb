class Income < ApplicationRecord

  belongs_to :user

  validates :amount, :user_id, :frequency, :presence => true

end

class Expense < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :frequency, :presence => true

end

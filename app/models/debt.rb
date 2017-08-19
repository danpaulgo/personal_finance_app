class Debt < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :interest, :compound_frequency, :presence => true
  validates_presence_of :payment_frequency, if: :payment?


end

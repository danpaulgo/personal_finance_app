class Debt < ApplicationRecord

  belongs_to :user

  validates :amount, :user_id, :interest, :compound_frequency, :presence => true

end

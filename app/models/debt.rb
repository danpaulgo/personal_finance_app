class Debt < ApplicationRecord

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :interest, :compound_frequency, :presence => true

end

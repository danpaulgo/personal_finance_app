class Asset < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :presence => true
  validates_inclusion_of :liquid ,:in => [true, false]
  validates_presence_of :compound_frequency, if: :interest?

end

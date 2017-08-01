class Credit < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :presence => true
  validates_inclusion_of :liquid ,:in => [true, false]

end

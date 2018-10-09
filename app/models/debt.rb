class Debt < ApplicationRecord

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :interest, :compound_frequency, :presence => true

  include UserResource

  def associated_transfers
    Transfer.where(type_id: 38).where(destination_id: id)
  end

end

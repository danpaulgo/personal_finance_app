class Transfer < ApplicationRecord

  belongs_to :user

  validates :name, :user_id, :liquid_asset_from_id, :destination_id, :type_id, :next_date, :amount, :frequency, presence: true

  include UserResource

  def asset_liquid?
    Asset.find_by(id: liquid_asset_from_id).liquid == true
  end

  def origin
    Asset.find(liquid_asset_from_id)
  end

  def destination
    type_id == 37 ? Asset.find_by(id: destination_id) : Debt.find_by(id: destination_id)
  end

  # def name
  #   "#{origin.name} > #{destination.name}"
  # end

end

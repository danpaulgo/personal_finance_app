class Transfer < ApplicationRecord

  belongs_to :user

  validates :user_id, :liquid_asset_from_id, :destination_id, :type_id, :next_date, :amount, :frequency, presence: true

  def type
    ResourceType.find(self.type_id)
  end

  def asset_liquid?
    Asset.find_by(id: liquid_asset_from_id).liquid == true
  end

  def name
    type_id == 36 ? destination = Asset.find_by(id: destination_id) : destination = Debt.find_by(id: destination_id)
    "#{Asset.find_by(id: liquid_asset_from_id).name} > #{destination.name}"
  end

end

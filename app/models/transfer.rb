class Transfer < ApplicationRecord

  belongs_to :user

  validates :user_id, :liquid_asset_from_id, :destination_id, :type_id, :next_date, :amount, :frequency, presence: true

  def type
    ResourceType.find(self.type_id)
  end

end

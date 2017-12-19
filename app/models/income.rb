class Income < ApplicationRecord

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :associated_asset_id, :next_date, :frequency, presence: true

  def type
    ResourceType.find(self.type_id)
  end

end

class Transfer < ApplicationRecord

  belongs_to :user

  validates :user_id, :liquid_asset_from_id, :destination_id, :transfer_type, :next_date, :amount, :frequency, presence: true

end

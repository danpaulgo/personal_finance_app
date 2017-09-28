class Income < ApplicationRecord

  belongs_to :user

  validates :amount, :user_id, :associated_asset_id, :next_date :frequency, :presence => true

end

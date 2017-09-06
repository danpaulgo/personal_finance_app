class AssetLiquid < ApplicationRecord

  belongs_to :user

  validates :name, :amount, :user_id, :presence => true
  validates_presence_of :compound_frequency, if: :interest?

end

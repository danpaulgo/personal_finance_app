class Expense < ApplicationRecord

  include UserResource

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :frequency, :associated_asset_id, :next_date, presence: true

end

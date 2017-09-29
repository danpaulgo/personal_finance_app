class Expense < ApplicationRecord

  belongs_to :user

  validates :type_id, :amount, :user_id, :frequency, :associated_asset_id, :next_date, presence: true

  # def make_payment(debt, amount, pay_from)
  #   debt.amount -= amount
  #   pay_from.amount -= amount
  # end

end

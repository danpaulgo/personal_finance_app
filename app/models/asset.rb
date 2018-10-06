class Asset < ApplicationRecord

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :presence => true
  validates_inclusion_of :liquid, :primary ,:in => [true, false]
  validates_presence_of :compound_frequency, if: :interest?

  include UserResource

  def to_s
    name
  end

  def associated_transfers_outgoing
    Transfer.where(liquid_asset_from_id: id)
  end

  def associated_transfers_incoming
    Transfer.where(type_id: 36).where(destination_id: id)
  end

  def associated_incomes
    Income.where(associated_asset_id: id)
  end

  def associated_expenses
    Expense.where(associated_asset_id: id)
  end

  def all_category_actions(category, no_of_years)
    send("associated_#{category}").map{|resource| resource.action_dates(no_of_years)}.flatten
  end

  def all_actions(direction, no_of_years)
    case direction
    when "incoming"
      categories = ["transfers_incoming", "incomes"]
    when "outgoing"
      categories = ["transfers_outgoing", "expenses"]
    end
    actions_array = []
    categories.each{|category| actions_array += all_category_actions(category, no_of_years)}
    actions_array.sort_by{|h| h[:date]}
  end

  def all_action_dates(no_of_years)
    dates_array = []
    ["incoming", "outgoing"].each do |direction|
      all_actions(direction, no_of_years).each{|action| dates_array.push(action[:date])}
    end
    dates_array.sort.uniq
  end

end

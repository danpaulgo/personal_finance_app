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
    Transfer.where(type_id: 37).where(destination_id: id)
  end

  def associated_incomes
    Income.where(associated_asset_id: id)
  end

  def associated_expenses
    Expense.where(associated_asset_id: id)
  end

  def all_category_actions(category, last_date)
    send("associated_#{category}").map{|resource| resource.action_dates(last_date)}.flatten
  end

  def all_actions(direction, last_date)
    case direction
    when "incoming"
      categories = ["transfers_incoming", "incomes"]
    when "outgoing"
      categories = ["transfers_outgoing", "expenses"]
    end
    actions_array = []
    categories.each{|category| actions_array += all_category_actions(category, last_date)}
    actions_array.sort_by{|h| h[:date]}
  end

  def all_action_dates(last_date)
    dates_array = []
    ["incoming", "outgoing"].each do |direction|
      all_actions(direction, last_date).each{|action| dates_array.push(action[:date])}
    end
    dates_array.sort.uniq
  end

  def future_value(date)
    current_value = amount
    add = 0
    subtract = 0
    date_array = all_action_dates(date)
    incoming_actions = all_actions("incoming", date)
    outgoing_actions = all_actions("outgoing", date)
    while date_array.count > 0
      incoming_actions.select{|a| a[:date] == date_array[0]}.each{|a| add += a[:amount]}
      outgoing_actions.select{|a| a[:date] == date_array[0]}.each{|a| subtract += a[:amount]}
      date_array.delete_at(0)
    end
    current_value + add - subtract
  end

end

module UsersHelper

  def net_worth(type = "total")
    # binding.pry
    net_worth = self.send("resource_total", "assets", type) -
    self.send("resource_total", "debts", type)
    # binding.pry
    Money.new((net_worth*100),"USD").format
  end

  def resource_total(resource_string, type = "total")
    all = self.send(resource_string)
    total = 0.0
    all.each do |resource|
      if type == "liquid"
        if !(resource.methods.include?(:liquid) && resource.liquid == false)
          total += resource.amount
        end
      else
        total += resource.amount
      end
    end
    total
  end

  def calculate_future_net_worth(date)
    # Add up credits, assets with interest, and income. Subtract debts with interest and expenses
    total_assets = resource_future_total("assets", date)
    total_income = resource_generated_total("incomes", date)
    total_debts = resource_future_total("debts", date)
    total_expenses = resource_generated_total("expenses", date)
    total = total_assets + total_income - total_debts - total_expenses
    self.future_net_worth = "#{Money.new((total*100),"USD").format} (as of #{date.to_date.strftime("%b %d, %Y")})"
  end

  # resource.future_value instead?
  def future_value(resource, date)
    if resource.interest == 0.0
      resource.amount
    else
      time_length = days_until(date)
      self.compound(resource, time_length)
    end
  end

  def resource_future_total(resource_string, date)
    total = 0
    self.send(resource_string).each do |resource|
      total += future_value(resource, date)
    end
    total
  end

  def generated_amount(resource, date)
    period_length = 0
    case resource.frequency
    when "Daily"
      period_length = 1.0
    when "Weekly"
      period_length = 7.0
    when "Monthly"
      period_length = 30.4375
    when "Yearly"
      period_length = 365.25
    end
    amount_per_day = resource.amount/period_length
    time_length = days_until(date)
    amount_per_day * time_length
  end

  def resource_generated_total(resource_string, date)
    total = 0
    self.send(resource_string).each do |resource|
      total += generated_amount(resource, date)
    end
    total
  end

  def days_until(date)
    date.to_date - Time.now.to_date
  end

  def compound(asset, time_length)
    principal = asset.amount
    rate = asset.interest/100
    number_of_periods = 0
    case asset.compound_frequency
    when "Daily"
      number_of_periods = 365
    when "Weekly"
      number_of_periods = 52
    when "Monthly"
      number_of_periods = 12
    when "Yearly"
      number_of_periods = 1
    end
    exponent = number_of_periods * (time_length/365)
    principal*(1+(rate/number_of_periods))**exponent
  end

  def monthly_(direction)
    total = 0.0
    self.send(direction).each do |income|
      monthly = 0.0
      case income.frequency
      when "Daily"
        monthly = (income.amount * 365.0) / 12.0
      when "Weekly"
        monthly = income.amount * (30.625/7.0)
      when "Monthly"
        monthly = income.amount
      when "Yearly"
        monthly = income.amount/12.0
      end
      total += monthly
    end
    total
  end


    # def compound_daily(asset, time_length)
    #   new_value = asset.amount
    #   time_length.times do
    #     new_value += (new_value * (asset.interest/100/365.25))
    #   end
    #   new_value
    # end

    # def compound_weekly(asset, time_length)
    #   new_value = asset.amount
    #   remainder = (time_length%30.4375).round
    #   # binding.pry
    #   (time_length/30.4375).floor.times do
    #     new_value += (new_value * (asset.interest/100/12))
    #   end
    #   new_value += (new_value * (asset.interest/100/12/remainder))
    # end
  
end

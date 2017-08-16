module UsersHelper

  def net_worth(user, type = "total")
    # binding.pry
    net_worth = user.send("resource_total", "assets", type) +
    user.send("resource_total", "credits", type) -
    user.send("resource_total", "debts", type)
    # binding.pry
    Money.new((net_worth*100),"USD").format
  end

  def calculate_future_net_worth(user, date)
    binding.pry
  end

  # private

    # def resource_total(resource_string)
    #   all = self.send(resource_string)
    #   total = 0.0
    #   all.each do |resource|
    #     total += resource.amount
    #   end
    #   total
    # end

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

    def date_in_future?(date)
      flash[:error] = "Must enter valid date in future"
      redirect_to root_path
    end

    def asset_future_value(asset, date)
      date_in_future?(date)
      days_until = date.to_date - Time.now.to_date
    end

    def debt_future_value(debt, date)

    end
  
end

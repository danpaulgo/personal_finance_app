module UserResource

  def type
    ResourceType.find(self.type_id)
  end

  def action_dates(last_date)
    if defined? next_date
      dates_array = []
      date = next_date.to_date
      end_date.nil? ? ending_date = date + 1000.years : ending_date = end_date.to_date
      while (date <= last_date) && (date <= ending_date)
        dates_array.push({date: date, amount: amount})
        case frequency
        when "One-Time"
          break
        when "Daily"
          date +=  1.day
        when "Weekly"
          date += 1.week
        when "Monthly"
          date += 1.month
        when "Yearly"
          date += 1.year
        end
      end
      dates_array
    end
  end

end
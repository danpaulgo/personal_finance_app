module UserResourcesHelper

  def input_fields(resource)
    permitted_input = ["type_id", "name", "amount", "frequency", "interest", "liquid", "primary", "compound_frequency", "associated_asset_id", "liquid_asset_from_id", "destination_id", "next_date", "end_date", "discontinued"]
    permitted_input & resource.attributes.keys
  end

  def show_fields(resource)
    permitted_input = ["name", "type_id", "amount", "interest", "frequency", "liquid"]
    permitted_input & input_fields(resource)
  end

  # Uses below functions to prepares data to be presented in table on index page by taking data from an object and placing it in a certain column
  def prep_data_for_table(object, column)
    case column
    when "type_id"
      type_output(object)
    when "amount"
      amount_output(nil_to_zero(object))
    when "interest"
      interest_output(object)      
    when "liquid"
      liquid_output(object)
    else
      object[column]
    end
  end

  def nil_to_zero(resource)
    resource.interest = 0 if resource.methods.include?("interest") && resource.interest == nil
    resource    
  end

  private

    # DATA DISPLAY HELPERS

    def type_output(object)
      ResourceType.find_by(id: object.type_id).name
    end

    def amount_output(object)
      Money.new((object.amount*100),"USD").format
    end

    def payment_output(object)
      Money.new((object.payment*100),"USD").format if object.payment
    end

    def interest_output(object)
      object.interest.nil? ? "0.0%" : object.interest.to_s + "%"
    end

    def liquid_output(object)
      object.liquid? ? "Yes" : "No"
    end

    # FORM HELPERS

    def is_liquid(type)
      if AssetsHelper::LIQUID_ASSET_TYPES.include?(type)
        true
      elsif AssetsHelper::ILLIQUID_ASSET_TYPES.include?(type)
        false
      else
        nil
      end
    end

    def form_user_name(f, part)
      f.text_field :"#{part}_name", class: "form-control", placeholder: "#{part.to_s.capitalize} Name"
    end

    def form_email(f)
      f.email_field :email, class: "form-control", placeholder: "Email"
    end

    def form_birthday(f)
      f.date_field :birthday, class: "form-control"
    end

    def form_password(f)
       f.password_field :password, class: "form-control", placeholder: "Password"
    end

    def form_password_confirmation(f)
      f.password_field :password_confirmation, class: "form-control", placeholder: "Confirm Password"
    end

    # Preps form fields for specific attributes
    def form_name(f, type_category = nil, name_value = nil)
      name_value = f.object.name if !f.object.name == nil
      f.text_field :name, placeholder: "Name", value: name_value
    end

    def form_amount(f, attr_name = "amount")
      f.number_field attr_name, placeholder: "Amount (USD)", step: '0.01', value: (f.object.amount.blank? ? nil : ('%.2f' % f.object.amount))
    end

    def form_interest(f)
      f.number_field :interest, placeholder: "Interest Rate (%)", step: :any
    end

    def form_frequency(f)
      frequency_selections = ["One-Time", "Daily", "Weekly", "Monthly", "Yearly"]
      f.select(:frequency, options_for_select(frequency_selections, selected: f.object.frequency), include_blank: "Select Frequency")
    end

    def form_compound_frequency(f)
      frequency_selections = ["Daily", "Weekly", "Monthly", "Quarterly", "Yearly", "I don't know", "Not Applicable"]
      f.select(:compound_frequency, options_for_select(frequency_selections, selected: f.object.compound_frequency), include_blank: "Select Frequency")
    end


    def form_payment(f)
      f.number_field :payment, placeholder: "Payment Amount (USD)", step: '0.01', value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    end

    def form_description(f)
      f.text_area :description, placeholder: "Description"
    end

    def form_select_asset(f, user)
      selections = user.assets
      f.select(:destination_id, options_for_select(selections, selected: f.object.destination_id), include_blank: "Select Asset")
    end

    def form_select_primary_asset(f, user, attr_name = "associated_asset_id")
      selections = user.assets.where(primary: true).map{|asset| [asset.name, asset.id]}
      f.select(:"#{attr_name}", options_for_select(selections, selected: f.object.send(attr_name)), include_blank: "Select Asset")
    end

    def form_select_liquid_asset(f, user, attr_name)
      selections = user.assets.where(liquid: true).map{|asset| [asset.name, asset.id]}
      f.select(:"#{attr_name}", options_for_select(selections, selected: f.object.send(attr_name)), include_blank: "Select Asset")
    end

    def form_select_debt(f, user)
      selections = user.debts.map{|debt| [debt.name, debt.id]}
      f.select(:destination_id, options_for_select(selections, selected: f.object.destination_id), include_blank: "Select Debt")
    end

    def form_select_type(f, resource_name)
      selections = ResourceType.all.where(resource_name_id: ResourceName.find_by(name: resource_name).id).sort_by{|rn| rn.name}.map{|type| [type.name, type.id]}
      selections.each_with_index do |val, index|
        if val[0] == "Other"
          selections.delete_at(index)
          selections.push(val)
          break
        end
      end
      f.select(:type_id, options_for_select(selections, selected: f.object.type_id), include_blank: "Select Type")
    end

    def form_end_date(f)
      f.date_field :end_date, value: (f.object.end_date.to_date if f.object.end_date)
    end

    def form_next_date(f)
      f.date_field :next_date, value: (f.object.next_date.to_date if f.object.next_date)
    end

    def form_liquid(f)
      f.label :liquid, "Yes", value: "true"
      f.radio_button :liquid, true
      f.label :liquid, "No", value: "false"
      f.radio_button :liquid, false
    end

    def first_of_next(time_measure)
      today = Date.today
      case time_measure
      when "Daily"
        today + 1
      when "Weekly"
        today.next_week(day= :sunday)
      when "Monthly"
        Date.today.at_beginning_of_month.next_month
      when "Yearly"
        Date.today.beginning_of_year() + 1.years
      end
    end

    def type_category(type)
      if !!type.name.match(/\sBill\z/)
        "Bill"
      elsif !!@type.name.match(/\sInsurance\z/)
        "Insurance"
      else
        @type.name
      end  
    end

end
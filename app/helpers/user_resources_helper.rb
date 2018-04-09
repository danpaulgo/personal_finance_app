module UserResourcesHelper

  def input_fields(resource)
    permitted_input = ["type_id", "name", "amount", "frequency", "interest", "liquid", "primary", "compound_frequency", "associated_asset_id", "liquid_asset_from_id", "next_date", "discontinued"]
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
    # when "liquid"
    #   liquid_output(object)
    when "interest"
      interest_output(object)      
    when "liquid"
      liquid_output(object)
    else
      object[column]
    end
  end


  #   if column == "liquid"
  #     liquid_output(object)
  #   elsif column == "amount" || column == "payment"
  #     nil_to_zero(object)
  #     amount_output(object)
  #   elsif column == "interest"
  #     interest_output(object)
  #   elsif object[column].blank?
  #     "N/a"
  #   else
  #     object[column]
  #   end
  # end

  # def form_field(f, attribute)
  #   case attribute
  #   when "amount"
  #     form_amount(f)
  #   when "interest"
  #     form_interest(f)
  #   when "compound_frequency"
  #     form_compound_frequency(f)
  #   when "frequency"
  #     form_frequency(f)
  #   when "frequency"
  #     form_liquid(f)
  #   # when "payment"
  #   #   form_payment(f)
  #   # when "payment_frequency"
  #   #   form_payment_frequency(f)
  #   when "description"
  #     form_description(f)
  #   else
  #     f.text_field attribute.to_sym, placeholder: attribute.capitalize
  #   end
  # end

    # if attribute == "amount" 
    #   form_amount(f)
    # elsif attribute == "interest"
    #   form_interest(f)
    # elsif attribute == "compound_frequency"
    #   form_compound_frequency(f)
    # elsif attribute == "frequency"
    #   form_frequency(f)
    # elsif attribute == "description"
    #   form_description(f)
    # elsif attribute == "payment"
    #   form_payment(f)
    # elsif attribute == "payment_frequency"
    #   form_payment_frequency(f)
    # else
    #   f.text_field attribute.to_sym, placeholder: attribute.capitalize
    # end

  def nil_to_zero(resource)
    # resource.amount = 0 if resource.amount == nil
    resource.interest = 0 if resource.methods.include?("interest") && resource.interest == nil
    resource
    # resource.payment = 0 if resource.methods.include?("payment") && resource.payment == nil    
  end

  private
      
    # Preps individual pieces of data to be displayed on index page
    # def liquid_output(object)
    #   object.liquid == true ? "Yes" : "No"
    # end

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

    def form_amount(f)
      f.number_field :amount, placeholder: "Amount (USD)", step: '0.01', value: (f.object.amount.blank? ? nil : ('%.2f' % f.object.amount))
    end

    def form_interest(f)
      f.number_field :interest, placeholder: "Interest Rate (%)", step: :any
    end

    # def form_compound_frequency(f)
    #   frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
    #   f.select(:compound_frequency, options_for_select(frequency_selections, selected: f.object.compound_frequency), include_blank: "Compound Frequency")
    # end

    def form_frequency(f)
      frequency_selections = ["One-time", "Daily", "Weekly", "Monthly", "Yearly"]
      f.select(:frequency, options_for_select(frequency_selections, selected: f.object.frequency), include_blank: "Select Frequency")
    end

    def form_compound_frequency(f)
      frequency_selections = ["Daily", "Weekly", "Monthly", "Quarterly", "Yearly", "I don't know"]
      f.select(:compound_frequency, options_for_select(frequency_selections, selected: f.object.compound_frequency), include_blank: "Select Frequency")
    end


    def form_payment(f)
      f.number_field :payment, placeholder: "Payment Amount (USD)", step: '0.01', value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    end

    # def form_payment_frequency(f)
    #   frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
    #   f.select(:payment_frequency, options_for_select(frequency_selections, selected: f.object.payment_frequency), include_blank: "Payment Frequency")

    # end

    def form_description(f)
      f.text_area :description, placeholder: "Description"
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

    def form_end_date(f)
      f.date_field :end_date
    end

    def form_next_date(f)
      f.date_field :next_date, value: f.object.next_date
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
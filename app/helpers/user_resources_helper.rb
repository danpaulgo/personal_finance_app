module UserResourcesHelper

  def input_fields(resource)
    permitted_input = ["name", "amount", "frequency", "interest", "liquid", "compound_frequency", "payment", "payment_frequency", "description"]
    input_fields = []
    resource.attributes.keys.each do |key|
      input_fields.push(key) unless key == "id" || key == "created_at" || key== "updated_at" || key == "user_id" 
    end
    permitted_input & input_fields
  end

  # Uses below functions to prepares data to be presented in table on index page by taking data from an object and placing it in a certain column
  def prep_data(object, column)
    case column
    when "amount"
      nil_to_zero(object)
      amount_output(object)
    when "liquid"
      liquid_output(object)
    when "interest"
      interest_output(object)      
    when "payment"
      nil_to_zero(object)
      binding.pry
      payment_output(object)
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

  def form_field(f, attribute)
    case attribute
    when "amount"
      form_amount(f)
    when "interest"
      form_interest(f)
    when "compound_frequency"
      form_compound_frequency(f)
    when "frequency"
      form_frequency(f)
    when "payment"
      form_payment(f)
    when "payment_frequency"
      form_payment_frequency(f)
    when "description"
      form_description(f)
    end
  end

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
    resource.amount = 0 if resource.amount == nil
    resource.interest = 0 if resource.methods.include?("interest") && resource.interest == nil
    resource.payment = 0 if resource.methods.include?("payment") && resource.payment == nil    
  end

  private
      
    # Preps individual pieces of data to be displayed on index page
    def liquid_output(object)
      object.liquid == true ? "Yes" : "No"
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

    # Preps form fields for specific attributes
    def form_amount(f)
      f.number_field :amount, placeholder: "Amount (USD)", step: '0.01', value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    end

    def form_interest(f)
      f.number_field :interest, placeholder: "Interest Rate (%)", step: :any
    end

    def form_compound_frequency(f)
      frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
      f.select(:compound_frequency, options_for_select(frequency_selections, selected: f.object.compound_frequency), include_blank: "Compound Frequency")
    end

    def form_frequency(f)
      frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
      f.select(:frequency, options_for_select(frequency_selections, selected: f.object.frequency), include_blank: "Select Frequency")
    end

    def form_payment(f)
      f.number_field :payment, placeholder: "Payment Amount (USD)", step: '0.01', value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    end

    def form_payment_frequency(f)
      frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
      f.select(:payment_frequency, options_for_select(frequency_selections, selected: f.object.payment_frequency), include_blank: "Payment Frequency")

    end

    def form_description(f)
      f.text_area :description, placeholder: "Description"
    end

end
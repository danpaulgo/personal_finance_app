module ResourcesHelper

  PERMITTED_INPUT = ["name", "amount", "frequency", "interest", "description", "liquid"]

  def input_fields(resource)
    input_fields = []
    resource.attributes.keys.each do |key|
      input_fields.push(key) unless key == "id" || key == "created_at" || key== "updated_at" || key == "user_id" 
    end
    PERMITTED_INPUT & input_fields
  end

  def prep_data(object, column)
    if column == "liquid"
      liquid_output(object)
    elsif column == "amount"
      amount_output(object)
    elsif column == "interest"
      interest_output(object)
    else
      object[column]
    end
  end

  # def form_lavel(attribute)
  #   f.label attribute.to_sym+":"
  # end

  def form_field(f, attribute)
    frequency_selections = ["Daily", "Weekly", "Monthly", "Yearly"]
    if attribute == "amount" 
      f.number_field :amount, placeholder: "Amount (USD)", step: '0.01', value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    elsif attribute == "interest"
      f.number_field :amount, placeholder: "Interest Rate (%)", step: :any, value: (f.object.amount.nil? ? nil : ('%.2f' % f.object.amount))
    elsif attribute == "frequency"
      f.select(:frequency, options_for_select(frequency_selections, selected: f.object.frequency), include_blank: "Select Frequency")
    elsif attribute == "description"
       f.text_area attribute.to_sym, placeholder: attribute.capitalize
    else
      f.text_field attribute.to_sym, placeholder: attribute.capitalize
    end
  end

    private
      
    # Preps data to be displayed on index page
    def liquid_output(object)
      object.liquid == true ? "Yes" : "No"
    end

    def amount_output(object)
      "$#{number_with_delimiter(('%.2f' % object.amount), :delimiter => ',')}"
    end

    def interest_output(object)
      object.interest.to_s + "%"
    end

    # Preps form fields for specific attributes
    def form_amount(f)
    end

    def form_interest(f)
    end

    def form_frequency(f)
    end

end
module UserResourcesHelper

  def input_fields(resource)
    permitted_input = ["name", "amount", "frequency", "interest", "description", "liquid", "compound_frequency"]
    input_fields = []
    resource.attributes.keys.each do |key|
      input_fields.push(key) unless key == "id" || key == "created_at" || key== "updated_at" || key == "user_id" 
    end
    permitted_input & input_fields
  end

  # Uses below functions to prepares data to be presented in table on index page by taking data from an object and placing it in a certain column
  def prep_data(object, column)
    if column == "liquid"
      liquid_output(object)
    elsif column == "amount"
      amount_output(object)
    elsif column == "interest"
      interest_output(object)
    elsif object[column].blank?
      "N/a"
    else
      object[column]
    end
  end

  def form_field(f, attribute)
    if attribute == "amount" 
      form_amount(f)
    elsif attribute == "interest"
      form_interest(f)
    elsif attribute == "compound_frequency"
      form_compound_frequency(f)
    elsif attribute == "frequency"
      form_frequency(f)
    elsif attribute == "description"
       form_description(f)
    else
      f.text_field attribute.to_sym, placeholder: attribute.capitalize
    end
  end

  def nil_to_zero(resource)
    resource.amount = 0 if resource.amount == nil
    resource.interest = 0 if resource.interest == nil  
  end

  private
      
    # Preps individual pieces of data to be displayed on index page
    def liquid_output(object)
      object.liquid == true ? "Yes" : "No"
    end

    def amount_output(object)
      Money.new((object.amount*100),"USD").format
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
      frequency_selections = ["Daily", "Weekly", "Monthly", "Quarterly", "Yearly"]
      f.select(:frequency, options_for_select(frequency_selections, selected: f.object.frequency), include_blank: "Select Frequency")
    end

    def form_description(f)
      f.text_area :description, placeholder: "Description"
    end

end
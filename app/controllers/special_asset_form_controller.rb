class SpecialAssetFormController < AssetsController

  before_action :set_type
  before_action :set_asset, only: [:step_two, :process_step_two, :step_three, :process_step_three, :step_four, :process_step_four, :process_step_five]
  # before_action only: [:step_two, :process_step_two, :step_three, :process_step_three] do
  #   set_loan_name(@type_category)
  # end

  def step_one
    @page_resource = "SpecialAssetSteps::StepOne#{@type_category}".constantize.new
    @owed = nil
    @paid = nil
    @submit_path = process_step_one_path(@type.id)
    @button_text = "Next"
    render 'resources/assets/special_assets/step_one.html.erb'
  end

  def step_one_redirect(step_one)
    if step_one.financed.to_boolean
      redirect_to step_two_path
    else
      redirect_to step_four_path
    end
  end

  def process_step_one
    clear_session_params
    @step_one = "SpecialAssetSteps::StepOne#{@type_category}".constantize.new(self.send("step_one_#{@type_category.downcase}_params"))
    @step_one.financed = params[:financed]
    if @step_one.valid?
      session[:special_asset_step_one] = @step_one
      step_one_redirect(@step_one)
    else
      @page_resource = @step_one
      if !@step_one.financed.nil?
        @owed = true if @step_one.financed.to_boolean == true
        @paid = true if @step_one.financed.to_boolean == false
      end
      if @type_category == "Property"
        @state = @step_one.location
        if !@step_one.income.nil?
          @gain = true if @step_one.income.to_boolean == true
          @no_gain = true if @step_one.income.to_boolean == false
        end
      end
      render 'resources/assets/special_assets/step_one.html.erb'
    end
  end

  def step_two
    @page_resource = SpecialAssetSteps::StepTwo.new
    set_loan_name(@type_category)
    # @loan = Debt.new
    # @payment = Transfer.new
    render 'resources/assets/special_assets/step_two.html.erb'
  end

  def process_step_two
    @step_two = SpecialAssetSteps::StepTwo.new(step_two_params)
    if @step_two.valid?
      session[:special_asset_step_two] = @step_two
      redirect_to step_three_path
    else
      @page_resource = @step_two
      set_loan_name(@type_category)
      render 'resources/assets/special_assets/step_two.html.erb'
    end
  end

  def step_three
    set_loan_name(@type_category)
    @page_resource = SpecialAssetSteps::StepThree.new
    render 'resources/assets/special_assets/step_three.html.erb'
  end

  def process_step_three
    



    # @expense = Expense.new(expense_params)
    # @expense.user = current_user
    # @expense.type_id = 35
    # @expense.name = "#{@type_category} payment (#{session_speicl_asset.name})"
    # if @expense.valid?
    #   session[:special_asset_payment] = @expense
    #   redirect_to step_four_path
    # else
    #   flash[:error] = @expense.errors.full_messages
    #   render 'resources/assets/special_assets/step_four.html.erb'
    # end
  end

  def step_four
    set_state_rate
    render 'resources/assets/special_assets/step_four.html.erb'
  end

  def process_step_four
    @average_rate = params[:average_rate]
    @custom_rate = params[:asset][:interest]
    if @custom_rate.blank? && @average_rate.blank?
      set_state_rate
      flash[:error] = ["Please make a selection before continuing"]
      render 'resources/assets/vehicle/step_four.html.erb'
    else
      @custom_rate = -@custom_rate if @type_category == "Vehicle"
      if !@custom_rate.blank?
        @special_asset.interest = @custom_rate
        @special_asset.compound_frequency = "Yearly"
      elsif @average_rate == "yes"
        if @type_category == "Vehicle"
          @special_asset.interest = -15
        elsif @type_category == "Property"
          @special_asset.interest = state_rate
        end
        @special_asset.compound_frequency = "Yearly"
      elsif @average_rate == "no"
        @special_asset.interest = 0
      end
      session[:special_asset] = @special_asset
      redirect_to step_five_path
    end
  end

  def step_five
    @user = current_user
    if @type_category == "Vehicle"
      @gasoline = Expense.new
      @car_insurance = Expense.new
      @vehicle_maintenance = Expense.new
      @miscellaneous = Expense.new
      render 'resources/assets/special_assets/step_five_vehicle.html.erb'
    elsif @type_category == "Property"
      @property_income = Income.new
      @property_tax = Expense.new
      @home_owners_insurance = Expense.new
      @utilities = Expense.new
      @property_maintenance = Expense.new
      # @miscellaneous = Expense.new
      render 'resources/assets/special_assets/step_five_property.html.erb'
    end
  end


  def process_step_five
    @user = current_user
    if @type_category == "Vehicle"
      expense_defaults = {gasoline: {type_id: 27, frequency: "Weekly", division: 1}, car_insurance: {type_id: 31, frequency: "Monthly", division: 12}, vehicle_maintenance: {type_id: 28, frequency: "Monthly", division: 12}, miscellaneous: {type_id: 35, frequency: "Monthly", division: 12}}
      @gasoline = Expense.new(expense_params("gasoline"))
      @car_insurance = Expense.new(expense_params("insurance"))
      @vehicle_maintenance = Expense.new(expense_params("vehicle_maintenance"))
      @miscellaneous = Expense.new(expense_params("miscellaneous"))
    elsif @type_category == "Property"
      expense_defaults = {property_tax: {type_id: 34, frequency: "Monthly", division: 12}, home_owners_insurance: {type_id: 31, frequency: "Monthly", division: 12}, utilities: {type_id: 29, frequency: "Monthly", division: 1}, property_maintenance: {type_id: 28, frequency: "Monthly", division: 12}, property_income: {type_id: 21, frequency: "Monthly", division: 1}}
      @property_tax = Expense.new(expense_params("property_tax"))
      @home_owners_insurance = Expense.new(expense_params("home_owners_insurance"))
      @utilities = Expense.new(expense_params("utilities"))
      @property_maintenance = Expense.new(expense_params("property_maintenance"))
      @property_income = Income.new(expense_params("property_income")) if !params[:property_income].nil?
    end
    expense_defaults.each do |key, value|
      expense = instance_variable_get("@#{key}")
      if !expense.nil?
        if (expense.amount.blank? || expense.associated_asset_id.blank?) && !(expense.amount.blank? && expense.associated_asset_id.blank?)
          flash[:error] = ["Please enter both an amount and an asset for each question you choose to answer"]
          render "resources/assets/special_assets/step_five_#{@type_category.downcase}.html.erb"
          break
        elsif !expense.amount.blank? && !expense.associated_asset_id.blank?
          if value[:division] != 1
            new_amount = expense.amount/value[:division]
            expense.amount = new_amount.ceil2(2)
          end
          expense.name = "#{key.to_s.to_title} (#{@special_asset.name})"
          expense.type_id = value[:type_id]
          expense.user = @user
          expense.frequency = value[:frequency]
          # FIX LINE BELOW
          expense.next_date = first_of_next(expense.frequency)
          session[:"#{key}"] = expense if expense.valid?
        end
      end
      # if num_of_loops == present_params.size
      #   process_special_asset_form
      # end
      if value == expense_defaults.values.last
        process_special_asset_form
      end
    end

  end

  def process_special_asset_form
    # Check each session key for nil values. Instantiate and save objects for all values that are not nil. Reset all session keys to nil.
    create_objects_from_session
    clear_session_params
    if session[:form_type] != :intro_quiz
      redirect_to assets_path
    else
      case session_speicl_asset.type.name
      when "Property"
        redirect_to iq_step_four_path
      when "Vehicle"
        redirect_to iq_step_five_path
      end
    end
  end

  def present_params
    special_asset_defaults.map{ |type_hash| type_hash if !session[type_hash[:session_name]].blank?}.compact
  end

  def create_objects_from_session
    flash[:success] = []
    present_params.each do |type_hash|
      session_value = session[type_hash[:session_name]]
      if session_value.is_a?(Hash)
        new_instance = type_hash[:resource_type].constantize.create(session_value)
      else
        new_instance = session_value
        session_value.save
      end
      if new_instance.errors.empty?
        resource_name = type_hash[:session_name].to_s.gsub("_", " ").capitalize
        flash[:success] += ["#{resource_name} successfully created (#{type_hash[:resource_type]})"]
      end
    end
  end

  def clear_session_params
    present_params.each do |type_hash|
      session[type_hash[:session_name]] = nil
    end
  end

  private

    def special_asset_defaults 
      [
        {session_name: :special_asset, resource_type: "Asset"}, 
        {session_name: :special_asset_loan, resource_type: "Debt"}, 
        {session_name: :special_asset_loan_payment, resource_type: "Transfer"}, 
        {session_name: :special_asset_payment, resource_type: "Expense"}, 
        # VEHICLE FORM
        {session_name: :gasoline, resource_type: "Expense"}, 
        {session_name: :car_insurance, resource_type: "Expense"}, 
        {session_name: :vehicle_maintenance, resource_type: "Expense"}, 
        {session_name: :miscellaneous, resource_type: "Expense"}, 
        # PROPERTY FORM
        {session_name: :property_income, resource_type: "Income"}, 
        {session_name: :property_tax, resource_type: "Expense"}, 
        {session_name: :home_owners_insurance, resource_type: "Expense"}, 
        {session_name: :property_maintenance, resource_type: "Expense"},
        {session_name: :utilities, resource_type: "Expense"} 
      ]
    end



    def state_rate
      if session[:property_location] == "NA"
        @na = true
        5.4
      else
        RealEstateAppreciation.find_by(abbreviation: session[:property_location]).appreciation
      end
    end

    def set_state_rate
      if @type_category == "Property"
        redirect_to "/assets/new/property" unless @state = session[:property_location]
        @rate = state_rate
      end
    end

    def set_type
      @type = ResourceType.find_by(id: params[:special_asset])
      @type_category = @type.name.to_title
    end

    def set_asset
      @special_asset = session[:special_asset]
    end

    # def set_form_variables
      
      
    #   set_loan_name(@type_category)
    # end

    def set_loan_name(type_category)
      case type_category
      when "Property"
        @loan_name = "mortgage"
      when "Vehicle"
        @loan_name = "vehicle loan"
      end
    end

    def debt_params
      params.require(:debt).permit(:type_id, :name, :amount, :interest, :compound_frequency)
    end

    def payment_params
      params.require(:payment).permit(:amount, :frequency, :liquid_asset_from_id, :next_date)
    end

    def expense_params(expense_name = "expense")
      params.require(:"#{expense_name}").permit(:amount, :frequency, :associated_asset_id, :next_date, :end_date)
    end

    def step_one_vehicle_params
      params.require(:special_asset_steps_step_one_vehicle).permit(:name, :amount, :financed)
    end

    def step_one_property_params
      params.require(:special_asset_steps_step_one_property).permit(:name, :amount, :financed, :location, :income)
    end

    def step_two_params
      params.require(:special_asset_steps_step_two).permit(:amount, :interest, :compound_frequency)
    end

end

class SpecialAssetFormController < AssetsController

  before_action :set_form_variables

  def process_step_one
    clear_session_params
    @special_asset.user = current_user
    @special_asset.primary = false
    @financed = params[:financed]
    if @special_asset.name.blank? || @special_asset.amount == nil || @special_asset == nil
      @page_resource = @special_asset
      @submit_path = process_step_one_path
      @button_text = "Next"
      @owed = true if @financed == "true"
      @paid = true if @financed == "false"
      @type_category = @page_resource.type.name
      flash[:error] = ["Please fill in all fields"]
      render "resources/assets/new"
    else
      session[:special_asset] = @special_asset
      session[:property_location] = params[:location] if @type_category == "Property"
      if @financed == "true"
        redirect_to step_two_path
      else
        redirect_to step_four_path
      end
    end
  end

  def session_speicl_asset
    Asset.new(session[:special_asset])
  end

  def step_two
    @loan = Debt.new
    @payment = Transfer.new
    render 'resources/assets/vehicle/step_two.html.erb'
  end

  def process_step_two
    # call .valid? on @loan and debt instead of saving. use fake destination_id on payment to validate
    @loan = Debt.new(debt_params)
    @loan.user = current_user
    @loan.name = "#{@type_category} loan (#{session_speicl_asset.name})"
    @loan.type_id = @type.id
    @payment = Transfer.new(payment_params)
    @payment.user = current_user
    @payment.transfer_type = "Debt Payment"
    @payment.destination_id = 1
    if @loan.valid? && @payment.valid?
      session[:special_asset_loan] = @loan
      session[:special_asset_loan_payment] = @payment
      redirect_to step_four_path
    else
      @payment.valid?
      flash[:error] = @loan.errors.full_messages + @payment.errors.full_messages
      render 'resources/assets/vehicle/step_two.html.erb'
    end
  end

  def step_three
    @expense = Expense.new
    render 'resources/assets/vehicle/step_three.html.erb'
  end

  def process_step_three
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    @expense.type_id = @type.id
    @expense.name = "#{@type_category} payment (#{session_speicl_asset.name})"
    if @expense.valid?
      session[:special_asset_payment] = @expense
      redirect_to step_four_path
    else
      flash[:error] = @expense.errors.full_messages
      render 'resources/assets/vehicle/step_three.html.erb'
    end
  end

  def step_four
    set_state_rate

    render 'resources/assets/vehicle/step_four.html.erb'
  end

  def process_step_four
    binding.pry
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
    @gasoline = Expense.new
    @insurance = Expense.new
    @maintenance = Expense.new
    @miscellaneous = Expense.new
    render 'resources/assets/vehicle/step_five.html.erb'
  end

  def process_step_five

    expense_defaults = {gasoline: {type_id: 27, frequency: "Monthly"}, insurance: {type_id: 37, frequency: "Yearly"}, maintenance: {type_id: 29, frequency: "Yearly"}, miscellaneous: {type_id: 42, frequency: "Yearly"}}

    @vehicle = session_vehicle
    @user = current_user
    @gasoline = Expense.new(expense_params("gasoline"))
    @insurance = Expense.new(expense_params("insurance"))
    @maintenance = Expense.new(expense_params("maintenance"))
    @miscellaneous = Expense.new(expense_params("miscellaneous"))
    
    expense_defaults.each do |key, value|
      expense = instance_variable_get("@#{key}")
      if (expense.amount.blank? || expense.associated_asset_id.blank?) && !(expense.amount.blank? && expense.associated_asset_id.blank?)
        flash[:error] = ["Please enter both an amount and an asset for each question you choose to answer"]
        render 'resources/assets/vehicle/step_five.html.erb'
        break
      else
        expense.name = "#{key.capitalize} (#{@vehicle.name})"
        expense.type_id = value[:type_id]
        expense.user = @user
        expense.frequency = value[:frequency]
        session[:"vehicle_#{key}"] = expense if expense.valid?
        if value == expense_defaults.values.last
          process_vehicle_form
        end
      end
    end

  end

  def process_special_asset_form
    # Check each session key for nil values. Instantiate and save objects for all values that are not nil. Reset all session keys to nil.
    create_objects_from_session
    clear_session_vehicle_params
    redirect_to root_path
  end

  def present_params
    @@new_instances.map{ |type_hash| type_hash if !session[type_hash[:session_name]].blank?}.compact
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
    @@session_vehicle_defaults.each do |type_hash|
      session[type_hash[:session_name]] = nil
    end
  end

  private

    def session_vehicle_defaults 
     [{session_name: :vehicle, resource_type: "Asset"}, {session_name: :vehicle_loan, resource_type: "Debt"}, {session_name: :vehicle_loan_payment, resource_type: "Transfer"}, {session_name: :vehicle_payment, resource_type: "Expense"}, {session_name: :vehicle_gasoline, resource_type: "Expense"}, {session_name: :vehicle_insurance, resource_type: "Expense"}, {session_name: :vehicle_maintenance, resource_type: "Expense"}, {session_name: :vehicle_miscellaneous, resource_type: "Expense"}]
    end

    def session_property_defaults

    end

    def state_rate
      RealEstateAppreciation.find_by(state: session[:property_location]).appreciation
    end

    def set_state_rate
      if @type_category == "Property"
        redirect_to "/assets/new/property" unless @state = session[:property_location]
        @rate = state_rate
      end
    end

    def set_form_variables
      @type_category = params[:special_asset].to_title
      @type = ResourceType.find_by(name: @type_category)
      @special_asset = Asset.new(session[:asset_params])
      set_loan_name(@type_category)
    end

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

end

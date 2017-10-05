class VehicleFormController < AssetsController

  before_action :set_vehicle_form_variables

  def process_vehicle_step_one
    clear_session_vehicle_params
    @page_resource = Asset.new(asset_params)
    @page_resource.user_id = current_user.id
    @financed = params[:financed]
    if @page_resource.name.blank? || @page_resource.amount == nil || @financed == nil
      @submit_path = process_vehicle_step_one_path
      @button_text = "Next"
      @owed = true if @financed == "true"
      @paid = true if @financed == "false"
      @type_category = "Vehicle"
      flash[:error] = "Please fill in all fields"
      render "resources/assets/new"
    else
      binding.pry
      session[:vehicle] = @page_resource
      if @financed == "true"
        redirect_to vehicle_step_two_path
      else
        redirect_to vehicle_step_three_path
      end
    end
  end

  def session_vehicle
    Asset.new(session[:vehicle])
  end

  def vehicle_step_two
    @loan = Debt.new
    @payment = Transfer.new
    render 'resources/assets/vehicle/step_two.html.erb'
  end

  def process_vehicle_step_two
    # call .valid? on @loan and debt instead of saving. use fake destination_id on payment to validate
    @loan = Debt.new(debt_params)
    @loan.user = current_user
    @loan.name = "#{session_vehicle.name} loan"
    @loan.type_id = 16
    @payment = Transfer.new(payment_params)
    @payment.user = current_user
    @payment.transfer_type = "Debt Payment"
    @payment.destination_id = 1
    if @loan.valid? && @payment.valid?
      session[:vehicle_loan] = @loan
      session[:vehicle_loan_payment] = @payment
      redirect_to vehicle_step_four_path
    else
      @payment.valid?
      @errors = @loan.errors.full_messages + @payment.errors.full_messages
      flash[:error] = @errors.join(", ")
      render 'resources/assets/vehicle/step_two.html.erb'
    end
  end

  def vehicle_step_three
    @expense = Expense.new
    render 'resources/assets/vehicle/step_three.html.erb'
  end

  def process_vehicle_step_three
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    @expense.type_id = 42
    @expense.name = "#{session_vehicle.name} payment"
    if @expense.valid?
      session[:vehicle_payment] = @expense
      redirect_to vehicle_step_four_path
    else
      flash[:error] = @expense.errors.full_messages.join(", ")
      render 'resources/assets/vehicle/step_three.html.erb'
    end
  end

  def vehicle_step_four
    render 'resources/assets/vehicle/step_four.html.erb'
  end

  def process_vehicle_step_four
    @vehicle = session_vehicle
    @depreciate = params[:depreciation]
    @custom_rate = params[:asset][:interest]
    if @custom_rate.blank? && @depreciate.blank?
      flash[:error] = "Please make a selection before continuing"
      render 'resources/assets/vehicle/step_four.html.erb'
    else
      if !@custom_rate.blank?
        @vehicle.interest ="-#{@custom_rate}".to_i
        @vehicle.compound_frequency = "Yearly"
      elsif @depreciate == "yes"
        @vehicle.interest = -15
        @vehicle.compound_frequency = "Yearly"
      elsif @depreciate == "no"
        @vehicle.interest = 0
      end
      session[:vehicle] = @vehicle
      redirect_to vehicle_step_five_path
    end
  end

  def vehicle_step_five
    @user = current_user
    @gasoline = Expense.new
    @insurance = Expense.new
    @maintenance = Expense.new
    @misc = Expense.new
    render 'resources/assets/vehicle/step_five.html.erb'
  end

  def process_vehicle_step_five

    expense_defaults = {gasoline: {type_id: 27, frequency: "Monthly"}, insurance: {type_id: 37, frequency: "Yearly"}, maintenance: {type_id: 29, frequency: "Yearly"}, misc: {type_id: 42, frequency: "Yearly"}}

    @vehicle = session_vehicle
    @user = current_user
    @gasoline = Expense.new(expense_params("gasoline"))
    @insurance = Expense.new(expense_params("insurance"))
    @maintenance = Expense.new(expense_params("maintenance"))
    @misc = Expense.new(expense_params("misc"))
    
    expense_defaults.each do |key, value|
      expense = instance_variable_get("@#{key}")
      if (expense.amount.blank? || expense.associated_asset_id.blank?) && !(expense.amount.blank? && expense.associated_asset_id.blank?)
        flash[:error] = "Please enter both an amount and an asset for each question you choose to answer"
        render 'resources/assets/vehicle/step_five.html.erb'
        break
      else
        expense.name = "#{@vehicle.name} (#{key})"
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

  @@new_instances_types = [{session_name: :vehicle, resource_name: "Asset"}, {session_name: :vehicle_loan, resource_name: "Debt"}, {session_name: :vehicle_loan_payment, resource_name: "Transfer"}, {session_name: :vehicle_payment, resource_name: "Expense"}, {session_name: :vehicle_gasoline, resource_name: "Expense"}, {session_name: :vehicle_insurance, resource_name: "Expense"}, {session_name: :vehicle_maintenance, resource_name: "Expense"}, {session_name: :vehicle_misc, resource_name: "Expense"}]

  def process_vehicle_form
    # Check each session key for nil values. Instantiate and save objects for all values that are not nil. Reset all session keys to nil.
    create_objects_from_session
    clear_session_vehicle_params
    redirect_to root_path
  end

  def present_params
    @@new_instances_types.map{ |type_hash| type_hash if !session[type_hash[:session_name]].blank?}.compact
  end

  def create_objects_from_session
    present_params.each do |type_hash|
      session_value = session[type_hash[:session_name]]
      if session_value.is_a?(Hash)
        type_hash[:resource_name].constantize.create(session_value)
      else
        session_value
      end
    end
  end

  def clear_session_vehicle_params
    @@new_instances_types.each do |type_hash|
      session[type_hash[:session_name]] = nil
    end
  end

  private

    def set_vehicle_form_variables
      @type = ResourceType.find_by(name: "Vehicle")
      @type_category = "Vehicle"
      @page_resource = Asset.new(session[:asset_params])
      # binding.pry
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

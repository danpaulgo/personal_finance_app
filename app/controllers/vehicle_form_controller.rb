class VehicleFormController < AssetsController

  before_action :set_vehicle_form_variables

  def process_vehicle_step_one
    @page_resource = Asset.new(asset_params)
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
      session[:asset_params] = asset_params
      if @financed == "true"
        redirect_to vehicle_step_two_path
      else
        redirect_to vehicle_step_three_path
      end
    end
  end

  def session_vehicle
    Asset.new(session[:asset_params])
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
    binding.pry
    if @loan.save && !params[:payment].values.any?{|v| v.blank?}
      @payment.destination_id = @loan.id
      @payment.user = current_user
      @payment.transfer_type = "Debt Payment"
      # CORRECT REPEATING CODE BELOW
      if @payment.save
        redirect_to vehicle_step_four_path
      else
        @loan.delete
        flash[:error] = "Make sure all fields are filled in correctly"
        render 'resources/assets/vehicle/step_two.html.erb'
      end
    else
      flash[:error] = "Make sure all fields are filled in correctly"
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

  end

  def vehicle_step_five
    @gasoline = Expense.new
    @insurance = Expense.new
    @maintenance = Expense.new
    @misc = Expense.new
    render 'resources/assets/vehicle/step_five.html.erb'
  end

  def process_vehicle_step_five

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

    def expense_params
      params.require(:expense).permit(:amount, :frequency, :associated_asset_id, :next_date, :end_date)
    end

end

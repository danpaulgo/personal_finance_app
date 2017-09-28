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

  def vehicle_step_two
    @loan = Debt.new
    @payment = Transfer.new
    render 'resources/assets/vehicle/step_two.html.erb'
  end

  def process_vehicle_step_two
    # render vehicle_step_two and create flash error if any of the values in params[:debt] or params[:payment] are blank or nil
    @loan = Debt.new(debt_params)
    @payment = Transfer.new(payment_params)
    if params[:debt].values.any?{|v| v.blank?} || params[:payment].values.any?{|v| v.blank?}
      flash[:error] = "Please fill in all fields"
      render 'resources/assets/vehicle/step_two.html.erb'
    end
  end

  def vehicle_step_three
    @expense = Expense.new
    render 'resources/assets/vehicle/step_three.html.erb'
  end

  def process_vehicle_step_three

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
      params.require(:payment).permit(:amount, :frequency, :liquid_asset_from_id)
    end

end

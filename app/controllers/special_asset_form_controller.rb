class SpecialAssetFormController < AssetsController

  before_action :set_type

  def step_1
    @page_resource = "SpecialAssetSteps::Step1#{@type_category}".constantize.new
    @owed = nil
    @paid = nil
    @submit_path = process_special_asset_step_1_path(@type.id)
    @button_text = "Next"
    render 'resources/assets/special_assets/step_1.html.erb'
  end

  def step_1_redirect(step_1)
    if step_1.financed.to_boolean
      redirect_to step_2_path
    else
      redirect_to step_four_path
    end
  end

  def process_step_1
    clear_session_params
    step_type = "1_#{@type_category.downcase}"
    @step_1 = "SpecialAssetSteps::Step1#{@type_category}".constantize.new(self.send(:step_params, step_type))
    @step_1.financed = params[:financed]
    if @step_1.valid?
      session[:special_asset_step_1] = @step_1
      step_1_redirect(@step_1)
    else
      @page_resource = @step_1
      if !@step_1.financed.nil?
        @owed = true if @step_1.financed.to_boolean == true
        @paid = true if @step_1.financed.to_boolean == false
      end
      if @type_category == "Property"
        @state = @step_1.location
        if !@step_1.income.nil?
          @gain = true if @step_1.income.to_boolean == true
          @no_gain = true if @step_1.income.to_boolean == false
        end
      end
      render 'resources/assets/special_assets/step_1.html.erb'
    end
  end

  def step_2
    session[:special_asset_step_2] = nil
    @page_resource = SpecialAssetSteps::Step2.new
    set_loan_name(@type_category)
    render 'resources/assets/special_assets/step_2.html.erb'
  end

  def process_step_2
    @step_2 = SpecialAssetSteps::Step2.new(step_params(2))
    if @step_2.valid?
      session[:special_asset_step_2] = @step_2
      redirect_to step_3_path
    else
      @page_resource = @step_2
      set_loan_name(@type_category)
      render 'resources/assets/special_assets/step_2.html.erb'
    end
  end

  def step_3
    set_loan_name(@type_category)
    @page_resource = SpecialAssetSteps::Step3.new
    render 'resources/assets/special_assets/step_3.html.erb'
  end

  def process_step_3

    @step_3 = SpecialAssetSteps::Step3.new(step_params(3))

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
    5.times do |n|
      n = n+1
      session[:"special_asset_step_#{n}"] = nil
    end
  end

  private

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
      @type = ResourceType.find_by(id: params[:asset_type_id])
      @type_category = @type.name.to_title
    end

    def set_loan_name(type_category)
      case type_category
      when "Property"
        @loan_name = "mortgage"
      when "Vehicle"
        @loan_name = "vehicle loan"
      end
    end
  
    define_method "step_params" do |step|
      step_number = step.to_s[0,1].to_i
      case step_number
      when 1
        permitted_array = :name, :amount, :financed, :location, :income
      when 2
        permitted_array = :amount, :interest, :compound_frequency
      when 3
        permitted_array = []
      when 4
        permitted_array = []
      when 5
        permitted_array = []
      end
      params.require(:"special_asset_steps_step#{step}").permit(permitted_array)
    end

    def create_special_asset

    end

    def create_loan

    end

    def create_loan_transfer

    end

    def create_loan_expense

    end

    def create_expense(type)

    end



end

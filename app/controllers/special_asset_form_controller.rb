class SpecialAssetFormController < AssetsController

  before_action :set_type

  def step_1
    @page_resource = "SpecialAssetSteps::Step1#{@type_category}".constantize.new
    step_1_set_vars
    render 'resources/assets/special_assets/step_1.html.erb'
  end

  def process_step_1
    clear_session_params
    step_type = "1_#{@type_category.downcase}"
    @step_1 = "SpecialAssetSteps::Step1#{@type_category}".constantize.new(step_params(step_type))
    validate_step @step_1
  end

  def step_2
    session[:special_asset_step_2] = nil
    @page_resource = SpecialAssetSteps::Step2.new
    set_loan_name(@type_category)
    render 'resources/assets/special_assets/step_2.html.erb'
  end

  def process_step_2
    @step_2 = SpecialAssetSteps::Step2.new(step_params(2))
    validate_step(@step_2)
  end

  def step_3
    session[:special_asset_step_3] = nil
    set_loan_name(@type_category)
    @page_resource = SpecialAssetSteps::Step3.new
    render 'resources/assets/special_assets/step_3.html.erb'
  end

  def process_step_3
    @step_3 = SpecialAssetSteps::Step3.new(step_params(3))
    validate_step(@step_3)
  end

  def step_4
    session[:special_asset_step_4] = nil
    @page_resource = SpecialAssetSteps::Step4.new
    step_4_set_vars
    render 'resources/assets/special_assets/step_4.html.erb'
  end

  def process_step_4
    @step_4 = SpecialAssetSteps::Step4.new(step_params(4))
    validate_step(@step_4)
  end

  def step_5
    session[:special_asset_step_5] = nil
    @page_resource = "SpecialAssetSteps::Step5#{@type_category}".constantize.new
    step_5_set_vars
    @expenses.each do |expense|
      @page_resource.send("#{expense}=", Hash.new)
    end
    render 'resources/assets/special_assets/step_5.html.erb'
  end

  def process_step_5
    step_type = "5_#{@type_category.downcase}"
    @step_5 = "SpecialAssetSteps::Step5#{@type_category}".constantize.new(step_params(step_type))
    validate_step @step_5
  end

  private

    def clear_session_params
      5.times do |n|
        n = n+1
        session[:"special_asset_step_#{n}"] = nil
      end
    end

    def set_type
      @type = ResourceType.find_by(id: params[:asset_type_id])
      @type_category = @type.name.to_title
    end

    def step_1_set_vars
      if !@page_resource.financed.nil?
        @owed = true if @page_resource.financed.to_boolean == true
        @paid = true if @page_resource.to_boolean == false
      end
      if @type_category == "Property"
        @state = @page_resource.location
        if !@page_resource.income.nil?
          @gain = true if @step_1.income.to_boolean == true
          @no_gain = true if @step_1.income.to_boolean == false
        end
      end
    end

    def step_1_redirect(financed)
      if financed
        redirect_to special_asset_step_2_path
      else
        session[:special_asset_step_2] = nil
        session[:special_asset_step_3] = nil
        redirect_to special_asset_step_4_path
      end
    end

    2.times do |n|
      step_number = n+2
      define_method "step_#{step_number}_set_vars" do
        set_loan_name(@type_category)
      end
    end

    def step_4_set_vars
      if @type_category == "Property"
        location = session[:special_asset_step_1].location 
        set_state(location)
      end
    end

    def step_5_set_vars
      @questions = {
        insurance: "How much do you pay for insurance on this #{@type_category.downcase} anually?",
        miscellaneous: "How much do you typically spend on miscellaneous expenses pertaining to this #{@type_category.downcase} anually?",
        gasoline: "How much do you typically spend on gasoline for this vehicle in a month?",
        maintenance: "How much do you typically spend on repairs and maintenance for this #{@type_category.downcase} anually?",
        tax: "How much do you pay in taxes on this property anually?",
        utilities: "How much do you typically pay for utilities (gas, electricity, water) in a month?",
        income: "How much income does this property generate monthly?"
      }
      @asset_selections = current_user.assets.where(primary: true).map{|asset| [asset.name, asset.id]}
      @expenses = @page_resource.all_attributes
      @expenses.delete(:income) if @type_category == "Property" && !session[:special_asset_step_1].income.to_boolean
    end

    def set_loan_name(type_category)
      case type_category
      when "Property"
        @loan_name = "mortgage"
      when "Vehicle"
        @loan_name = "vehicle loan"
      end
    end

    def set_state(location)
      if location == "NA"
        @na = true
        @rate = 5.4
      else
        state = RealEstateAppreciation.find_by(abbreviation: location)
        @rate = state.appreciation
        @state_name = state.name
      end
    end

    def validate_step(step)
      step_number = step.class.to_s.match(/\:\:Step\d/)[0].last.to_i
      if step.valid?
        flash.discard
        session[:"special_asset_step_#{step_number}"] = step
        successful_redirect(step_number)
      else
        @page_resource = step
        send "step_#{step_number}_set_vars"
        render "resources/assets/special_assets/step_#{step_number}.html.erb"
      end
    end

    def successful_redirect(step_number)
      next_step = step_number + 1
      case step_number
      when 1
        financed = session[:special_asset_step_1].financed.to_boolean
        step_1_redirect(financed)
      when 5
        process_special_asset_form
      else
        redirect_to send "special_asset_step_#{next_step}_path"
      end
    end

    def process_special_asset_form
      # Check each session key for nil values. Instantiate and save objects for all values that are not nil. Reset all session keys to nil. 
      if form_valid?
        create_objects_from_session
        clear_session_params
        redirect_to root_path
      else
        invalid_form_redirect
      end
    end

    def form_valid?
      valid = [session[:special_asset_step_1], session[:special_asset_step_4], session[:special_asset_step_5]].compact.size == 3
      invalid = session[:special_asset_step_3].nil? && !session[:special_asset_step_2].nil?
      valid && !invalid
    end

    def invalid_form_redirect
      clear_session_params
      flash[:success] = nil
      flash[:error] = ["Invalid form submission"]
      redirect_to root_path
    end

    def create_objects_from_session
      flash[:success] = []
      create_special_asset
      if present_steps == 1
        create_loan_expense
      elsif present_steps == 2
        create_loan
        create_loan_expense(:transfer)
      end
      present_expenses.each do |expense|
        binding.pry
        create_expense(expense)
      end
    end

    def present_steps
      if session[:special_asset_step_3].nil? 
        0
      elsif session[:special_asset_step_2].nil?
        1
      else
        2
      end
    end

    def present_expenses
      # @step_5 = session[:special_asset_step_5]
      expenses = []
      @step_5.all_attributes.each do |attribute|
        expenses.push attribute if !@step_5.send(attribute).values.all?{|v| v.blank?}
      end
      expenses
    end

    def step_params(step_number)
      
      if step_number.to_s[0,1] == "5"
        params.require(:"special_asset_steps_step#{step_number}").permit!
      else
        permitted_array = "SpecialAssetSteps::Step#{step_number.to_s.camelize}".constantize.new.all_attributes
        params.require(:"special_asset_steps_step#{step_number}").permit(permitted_array)
      #   initial = permitted_array
      #   permitted_array = []
      #   initial.each do |attr|
      #     permitted_array.push eval "{#{attr}: [:amount, :paid_using]}"
      #   end
      # end
      end
      
    end

    def save_resource(resource)
      if resource.save
        table = ResourceName.find_by(name: resource.class.name).table_name
        flash[:success].push "#{resource.name} successfully added to #{table}"
      else
        invalid_form_redirect
      end
    end

    def create_special_asset
      @special_asset = Asset.new
      @special_asset.user = current_user
      @special_asset.type_id = @type.id
      @special_asset.liquid = false
      @special_asset.primary = false
      @special_asset.name = session[:special_asset_step_1].name
      @special_asset.amount = session[:special_asset_step_1].amount.to_f
      @special_asset = add_interest_to(@special_asset)
      save_resource(@special_asset)
      session[:special_asset_id] = @special_asset.id
    end

    def add_interest_to(special_asset)
      if !session[:special_asset_step_4].all_attributes.all?{|a| a.blank?}
        special_asset.compound_frequency = "Yearly"
        if !session[:special_asset_step_4].custom_rate.blank?
          special_asset.interest = session[:special_asset_step_4].custom_rate.to_f
        else
          if @type_category == "Property"
            location = RealEstateAppreciation.find_by(abbreviation: session[:special_asset_step_1].location)
            special_asset.interest = location.appreciation
          elsif @type_category == "Vehicle"
            special_asset.interest = -15.0
          end
        end
        special_asset
      else
        invalid_form_redirect
      end
    end

    def create_loan
      set_loan_name(@type_category)
      @loan = Debt.new
      @loan.name = "#{@loan_name.capitalize} for '#{@special_asset}'"
      @loan.user = current_user
      @loan.type_id = ResourceType.find{|r| r.name.downcase == @loan_name}.id
      @loan.amount = session[:special_asset_step_2].amount.to_f
      @loan.interest = session[:special_asset_step_2].interest.to_f
      @loan.compound_frequency = session[:special_asset_step_2].compound_frequency
      save_resource(@loan)
      session[:special_asset_loan_id] = @loan.id
    end

    def create_loan_expense(type = nil)
      set_loan_name(@type_category)
      type == :transfer ? resource = Transfer.new : resource = Expense.new
      resource.name = "#{@loan_name.capitalize} payment for '#{@special_asset}'" if type != :transfer
      resource.user = current_user
      resource.amount = session[:special_asset_step_3].amount.to_f
      resource.frequency = session[:special_asset_step_3].frequency
      resource.next_date = session[:special_asset_step_3].next_date
      resource.end_date = session[:special_asset_step_3].end_date if !session[:special_asset_step_3].end_date.blank?
      if type == :transfer
        resource.liquid_asset_from_id = session[:special_asset_step_3].paid_using.to_i
        resource.destination_id = session[:special_asset_loan_id]
        resource.type_id = 38
      elsif type == nil
        resource.associated_asset_id = session[:special_asset_step_3].paid_using.to_i
        resource.type_id = 35
      end
      save_resource(resource)
    end

    def create_expense(present_expense)
      binding.pry
      special_asset_name = Asset.find(session[:special_asset_id]).name
      present_expense == :income ? resource = Income.new : resource = Expense.new 
      resource.user = current_user
      resource.name = "#{@type_category} #{present_expense.to_s} (#{special_asset_name})"
      resource.amount = @step_5.send(present_expense)[:amount]
      resource.associated_asset_id = @step_5.send(present_expense)[:paid_using]
      type = ResourceType.find_by(name: present_expense.to_s.capitalize)
      type.nil? ? resource.type_id = 35 : resource.type_id = type.id
      case present_expense
      when :insurance, :maintenance, :tax, :miscellaneous
        resource.next_date = Date.today.at_beginning_of_year.next_year
        resource.frequency = "Yearly"
      else
        resource.next_date = Date.today.at_beginning_of_month.next_month
        resource.frequency = "Monthly"
      end
      save_resource(resource)
    end

end
class AssetsController < UserResourcesController
  
  include AssetsControllerHelper
  self.set_resource("Asset")

  def vehicle_process_step_one
    @type_category = "Vehicle"
    @page_resource = Asset.new(asset_params)
    @financed = params[:financed]
    if @page_resource.name == nil || @page_resource.amount == nil || @financed == nil
      @submit_path = vehicle_process_step_one_path
      @button_text = "Next"
      @owed = true if @financed == "true"
      @paid = true if @financed == "false"
      @type = ResourceType.find_by(name: "Vehicle")
      @type_category = "Vehicle"
      flash[:error] = "Please fill in all fields"
      render "resources/assets/new"
    else
      # binding.pry
      session[:asset_params] = asset_params
      if @financed == "true"
        redirect_to vehicle_step_two_path
      else
        redirect_to vehicle_step_three_path
      end
    end
  end

  def vehicle_step_two
    # set_vehicle_form_variables
    render 'resources/assets/vehicle/step_two.html.erb'
  end

  def vehicle_process_step_two

  end

  def vehicle_step_three
    # set_vehicle_form_variables
    render 'resources/assets/vehicle/step_three.html.erb'
  end

  private

    def asset_params
      params.require(:asset).permit(:name, :type_id, :amount, :interest, :compound_frequency, :primary, :liquid)
    end

end

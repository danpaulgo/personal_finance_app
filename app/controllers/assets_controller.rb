class AssetsController < UserResourcesController
  self.set_resource("Asset")

  def vehicle_process_step_one
    @page_resource = Asset.new(asset_params)
    @financed = params[:financed]
    if @page_resource.name == nil || @page_resource.amount == nil || @financed == nil
      @submit_path = vehicle_process_step_one_path
      @button_text = "Next"
      @owed = true if @financed == "true"
      @paid = true if @financed == "false"
      @type = @type = ResourceType.find_by(name: "Vehicle")
      @type_category = @type.name
      flash[:error] = "Please fill in all fields"
      render "resources/assets/new"
    else
      binding.pry
      session[:new_asset] = @page_resource
    end
  end

  def vehicle_step_two
    @new_asset = Asset.new(asset_params)
    session[:new_asset] = @new_asset
    # binding.pry
    render 'resources/assets/car/step_two.html.erb'
  end

  def process_depreciation
    new_asset = session[:new_asset]

  end

  # def vehicle_step_three
  #   binding.pry
  #   raise params
  # end

  private

    def asset_params
      params.require(:asset).permit(:name, :type_id, :amount, :interest, :compound_frequency, :primary, :liquid)
    end

end

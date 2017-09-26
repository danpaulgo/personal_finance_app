class AssetsController < UserResourcesController
  self.set_resource("Asset")

  def vehicle_step_two
    new_asset = Asset.new(asset_params)
    session[:new_asset] = new_asset
    # binding.pry
    render 'resources/assets/car/step_two.html.erb'
  end

  def process_depreciation
    depreciate = params[:depreciation]
    binding.pry
  end

  # def vehicle_step_three
  #   binding.pry
  #   raise params
  # end

  private

    def asset_params
      params.require(:asset).permit(:name, :amount, :interest, :compound_frequency, :liquid)
    end

end

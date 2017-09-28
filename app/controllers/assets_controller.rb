class AssetsController < UserResourcesController
  
  include AssetsControllerHelper
  self.set_resource("Asset")

  private

    def asset_params
      params.require(:asset).permit(:name, :type_id, :amount, :interest, :compound_frequency, :primary, :liquid)
    end

end

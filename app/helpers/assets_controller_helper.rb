module AssetsControllerHelper
  
  def set_vehicle_form_variables
    @type = ResourceType.find_by(name: "Vehicle")
    @type_category = "Vehicle"
    @page_resource = Asset.new(session[:asset_params])
    # binding.pry
  end
end
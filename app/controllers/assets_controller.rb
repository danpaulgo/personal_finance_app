class AssetsController < UserResourcesController
  self.set_resource("Asset")

  def car_step_two
    @step_one_params = params
    render 'resources/assets/car/step_two.html.erb'
  end
end

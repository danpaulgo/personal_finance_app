module UserResources

  def index
    @all = current_user.send($resource_plural)
    render 'resources/index.html.erb'
  end

  def new
    @page_resource = $new_resource
    render 'resources/new.html.erb'
  end

  def create
    binding.pry
    @current = $resource.constantize.new(resource_params)
    @current.user_id = current_user.id
    redirect_to "/#{$resource_plural}" if @current.save
    binding.pry
  end

  def edit
    @page_resource = $resource.constantize.find_by(id: params[:id])
    render 'resources/edit.html.erb'
  end

  private

    def resource_params
      params.require($resource.downcase.to_sym).permit($new_resource.attributes.keys.map{|k| k.to_sym})
      # MAY WORK WITHOUT ".to_sym" METHOD
    end

end
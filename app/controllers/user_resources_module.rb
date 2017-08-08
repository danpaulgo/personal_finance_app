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
    @page_resource = $resource.constantize.new(resource_params)
    @page_resource.user_id = current_user.id
    if @page_resource.save
      flash[:success] = "#{$resource} saved"
      redirect_to "/#{$resource_plural}" 
    end
  end

  def edit
    render 'resources/edit.html.erb'
  end

  def update
    @page_resource.update_attributes(resource_params)
    if @page_resource.save
      flash[:success] = "#{$resource} updated"
      redirect_to "/#{$resource_plural}" 
    end
  end

  def destroy
    if @page_resource.destroy
      flash[:success] = "#{$resource} deleted"
      redirect_to "/#{$resource_plural}"
    end
  end

  # private :resource_params

    def resource_params
      params.require($resource.downcase.to_sym).permit(input_fields($new_resource).map{|pi| pi.to_sym})
      # MAY WORK WITHOUT ".to_sym" METHOD
    end

  # private :resource_params

end
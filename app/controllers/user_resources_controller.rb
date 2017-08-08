class UserResourcesController < ApplicationController
  # require_relative 'user_resources_module.rb'
  # include UserResources
  include SessionsHelper
  include ResourcesHelper

  before_action :access_granted
  before_action :correct_user, only: [:edit, :update, :destroy]

  def self.set_resource(resource)
    $resource = resource
    $resource_plural = $resource.pluralize.downcase
    $new_resource = $resource.constantize.new
  end

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

  private

    def resource_params
      params.require($resource.downcase.to_sym).permit(input_fields($new_resource).map{|pi| pi.to_sym})
      # MAY WORK WITHOUT ".to_sym" METHOD
    end

    def access_granted
      redirect_to login_path if !logged_in?
    end

    def correct_user
      @page_resource = $resource.constantize.find_by(id: params[:id])
      if !(@page_resource.user ==  current_user)
        flash[:error] = "Invalid User"
        redirect_to root_path
      end
    end

end

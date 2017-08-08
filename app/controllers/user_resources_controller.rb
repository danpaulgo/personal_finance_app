class UserResourcesController < ApplicationController
  require_relative 'user_resources_module.rb'
  include UserResources
  include SessionsHelper
  include ResourcesHelper

  before_action :access_granted
  before_action :correct_user, only: [:edit, :update, :destroy]

  def self.set_resource(resource)
    $resource = resource
    $resource_plural = $resource.pluralize.downcase
    $new_resource = $resource.constantize.new
  end

  private

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

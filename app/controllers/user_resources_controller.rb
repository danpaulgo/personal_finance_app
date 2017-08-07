class UserResourcesController < ApplicationController
  require_relative 'user_resources_module.rb'
  include UserResources
  include SessionsHelper

  before_action :access_granted

  def self.set_resource(resource)
    $resource = resource
    $resource_plural = $resource.pluralize.downcase
    $new_resource = $resource.constantize.new
  end

  private

    def access_granted
      redirect_to login_path if !logged_in?
    end

end

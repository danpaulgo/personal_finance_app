class UserResourcesController < ApplicationController
  # require_relative 'user_resources_module.rb'
  # include UserResources
  include SessionsHelper
  include UserResourcesHelper

  before_action :access_granted
  before_action :correct_user, only: [:edit, :update, :destroy]

  def self.set_resource(resource)
    $resource = resource
    $resource_plural = $resource.downcase.pluralize
    # $resource_name = ResourceName.find_by(table_name: $resource_plural).name
    # $resource_name_singular = $resource.split("_")[0].capitalize
    $new_resource = $resource.downcase.camelize.constantize.new
  end

  def index
    @all = current_user.send($resource_plural)
    render 'resources/index.html.erb'
  end

  def options
    @types = ResourceName.find_by(name: $resource).resource_types.sort_by{|type| type.name}.delete_if{|obj| obj.name == "Other"}
    render "resources/options.html.erb"
  end

  def new
    @page_resource = $new_resource
    @type = ResourceType.find_by(name: params[:type].split("_").map{|w| w.capitalize}.join(" "))
    if !!@type.name.match(/\sBill\z/)
      @type_category = "Bill"
    elsif !!@type.name.match(/\sInsurance\z/)
      @type_category = "Insurance"
    else
      @type_category = @type.name
    end  
    if @type && ResourceName.find_by(name: @page_resource.class.name).resource_types.include?(@type)
      case $resource
      when "Asset"
        if @type_category == "Car"
          @submit_path = car_step_two_path
          @button_text = "Next"
        elsif @type_category == "Real Estate"
          @submit_path = real_estate_step_two_path
          @button_text = "Next"
        else
          @submit_path = "/assets"
        end
        render 'resources/assets/new.html.erb'
      when "Debt"
        render 'resources/debts/new.html.erb'
      when "Income"
        render 'resources/incomes/new.html.erb'
      when "Expense"
        render 'resources/expenses/new.html.erb'
      end
    else
      flash[:error] = "Invalid #{@resource.class.name.downcase} type"
      redirect_to root_path
    end

    # render 'resources/new.html.erb'
  end

  def create
    @page_resource = $resource.constantize.new(resource_params)
    @page_resource.user_id = current_user.id
    @page_resource.type_id = params[:type_id]
    nil_to_zero(@page_resource)
    if @page_resource.save
      flash[:success] = "#{$resource} saved"
      redirect_to "/#{$resource_plural}" 
    else
      @type = ResourceType.find(params[:type_id])
      render "resources/#{$resource_plural}/new" 
    end
  end

  def edit
    render 'resources/edit.html.erb'
  end

  def update
    @page_resource.update_attributes(resource_params)
    nil_to_zero(@page_resource)
    if @page_resource.save
      flash[:success] = "#{$resource} updated"
      redirect_to "/#{$resource_plural}" 
    else
      render 'resources/edit'
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

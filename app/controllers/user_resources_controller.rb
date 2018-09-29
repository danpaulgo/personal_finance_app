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
    @user = current_user
    @all = @user.send($resource_plural).paginate(page: params[:page], per_page: 10)
    render 'resources/index'
  end

  def show
    @resource = current_user.send($resource_plural).find_by(id: params[:id])
    @type = @resource.type.name
    case $resource
    when "Income", "Expense"
      @associated_asset = Asset.find_by(id: @resource.associated_asset_id)
    when "Transfer"
      @out_account = Asset.find_by(id: @resource.liquid_asset_from_id)
      if @resource.type.id == 36
        @in_table = "assets"
        @in_account = Asset.find_by(id: @resource.destination_id)
      else
        @in_table = "debts"
        @in_account = Debt.find_by(id: @resource.destination_id)
      end
    end
    render 'resources/show'
  end

  def options
    @page_resource = $new_resource
    @title = "New #{$resource}"
    # Sends "Other" option to end of list
    # @type_selections.each_with_index do |val, index|
    #   if val[0] == "Other"
    #     @type_selections.delete_at(index)
    #     @type_selections.push(val)
    #     break
    #   end
    # end
    render "resources/options.html.erb"
  end

  def process_option
    @type = ResourceType.find_by(id: resource_params[:type_id])
    if @type.nil?
      flash[:error] = ["Please make a selection"]
      @page_resource = $new_resource
      @title = "Create New #{$resource}"
      @types = ResourceName.find_by(name: $resource).resource_types.sort_by{|type| type.name}
      @type_selections = @types.map{|type| [type.name, type.id] }
      # Sends "Other" option to end of list
      @type_selections.each_with_index do |val, index|
        if val[0] == "Other"
          @type_selections.delete_at(index)
          @type_selections.push(val)
          break
        end
      end
      render "resources/options.html.erb"
    elsif @type.id == 8 || @type.id == 9
      redirect_to special_asset_step_1_path(@type.id)
    else
      redirect_to "/#{$resource_plural}/new/#{@type.id}"
    end    
  end

  def new_redirect
    redirect_to "/#{$resource_plural}/options"
  end

  def new
    @page_resource = $new_resource
    @type = ResourceType.find_by(id: params[:type_id]) 
    if @type && ResourceName.find_by(name: $resource).resource_types.include?(@type)
      @type_category = type_category(@type)
      @form_type = "new"
      set_button_text(@form_type)
      render "resources/form_page"
    else
      flash[:error] = ["Invalid #{@page_resource.class.name.downcase} type"]
      redirect_to "/#{$resource_plural}/options"
    end
  end

  def create
    @page_resource = $resource.constantize.new(resource_params)
    @page_resource.user_id = current_user.id
    @type = @page_resource.type
    if $resource == "Asset"
      @type.id == 1 || @type.id == 2 ? @page_resource.primary = true : @page_resource.primary = false
    end
    nil_to_zero(@page_resource)
    if @page_resource.save
      flash[:success] = ["#{$resource} saved"]
      redirect_to "/#{$resource_plural}/#{@page_resource.id}" 
    else
      @type_category = type_category(@type)
      @button_text = "Add #{$resource}"
      @submit_path = "/#{$resource_plural}"
      @form_type = "new"
      set_button_text(@form_type)
      render "resources/form_page" 
    end
  end

  def edit
    @page_resource = current_user.send($resource_plural).find_by(id: params[:id])
    @form_type = "edit"
    set_button_text(@form_type)
    render "resources/form_page" 
  end

  def update
    if @page_resource.update(resource_params)
      flash[:success] = ["#{$resource} successfully updated"]
      redirect_to "/#{$resource_plural}/#{@page_resource.id}" 
    else
      @form_type = "edit"
      set_button_text(@form_type)
      render "resources/form_page" 
    end
  end

  def destroy
    if @page_resource.destroy
      flash[:success] = ["#{$resource} deleted"]
      redirect_to "/#{$resource_plural}"
    end
  end

  private

    # CHANGE TO INDIVIDUAL CONTROLLERS
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
        flash[:error] = ["Invalid User"]
        redirect_to root_path
      end
    end

    def set_button_text(form_type)
      case form_type
      when "new"
        @button_text = "Add #{$resource}"
      when "edit"
        @button_text = "Update #{$resource}"
      end
    end

end

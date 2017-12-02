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
    @page_resource = $new_resource
    @types = ResourceName.find_by(name: $resource).resource_types.sort_by{|type| type.name}
    @type_selections = @types.map do |type|
      [type.name, type.id]
    end
    # Sends "Other" option to end of list
    @type_selections.each_with_index do |val, index|
      if val[0] == "Other"
        @type_selections.delete_at(index)
        @type_selections.push(val)
        break
      end
    end
    render "resources/options.html.erb"
  end

  def process_option
    @type = ResourceType.find(resource_params[:type_id])
    @slug = @type.name.to_snake
    redirect_to "/#{$resource_plural}/new/#{@slug}"
  end

  def new
    @page_resource = $new_resource
    @type = ResourceType.find_by(name: params[:type].to_title)
    if @type && ResourceName.find_by(name: @page_resource.class.name).resource_types.include?(@type)
      if !!@type.name.match(/\sBill\z/)
        @type_category = "Bill"
      elsif !!@type.name.match(/\sInsurance\z/)
        @type_category = "Insurance"
      else
        @type_category = @type.name
      end  
      case $resource
      when "Asset"
        # Add default params to @page_resource
        if @type.name == "Vehicle" || @type.name == "Property"
          # Add default vehicle params to @page_resource
          @owed = nil
          @paid = nil
          @submit_path = process_step_one_path(params[:type])
          @button_text = "Next"
        else
          # Add additional default asset params to @page_resource
          @type.name == "Bank Account" || @type.name == "Cash on Hand" ? @primary = true : @primary = false
          @submit_path = assets_path
        end
        render 'resources/assets/new.html.erb'
      when "Debt"
        # Add default params to @page_resource
        render 'resources/debts/new.html.erb'
      when "Income"
        # Add default params to @page_resource
        render 'resources/incomes/new.html.erb'
      when "Expense"
        # Add default params to @page_resource
        render 'resources/expenses/new.html.erb'
      when "Transfer"
        # Add default params to @page_resource
        render 'resources/transfers/new.html.erb'
      end

    else
      flash[:error] = ["Invalid #{@page_resource.class.name.downcase} type"]
      redirect_to root_path
    end

    # render 'resources/new.html.erb'
  end

  def create
    @page_resource = $resource.constantize.new(resource_params)
    @page_resource.user_id = current_user.id
    nil_to_zero(@page_resource)
    if @page_resource.save
      flash[:success] = ["#{$resource} saved"]
      redirect_to "/#{$resource_plural}" 
    else
      @type = ResourceType.find(@page_resource.type_id)
      @type.name == "Bank Account" || @type.name == "Cash on Hand" ? @primary = true : @primary = false
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
      flash[:success] = ["#{$resource} updated"]
      redirect_to "/#{$resource_plural}" 
    else
      render 'resources/edit'
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

end

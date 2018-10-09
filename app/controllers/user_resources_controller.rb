class UserResourcesController < ApplicationController

  include SessionsHelper
  include UserResourcesHelper

  before_action :access_granted
  before_action :correct_user, only: [:edit, :update, :destroy]

  def self.set_resource(resource)
    $resource = resource
    $resource_plural = $resource.downcase.pluralize
    $new_resource = $resource.downcase.camelize.constantize.new
  end

  def index
    @user = current_user
    @all = @user.send($resource_plural).paginate(page: params[:page], per_page: 10)
    @sort_options = [["Name", "name"], ["Amount", "amount"], ["Date Added", "created_at"], ["Last Updated", "updated_at"]]
    @sort_direction = [["ASC", "asc"], ["DESC", "desc"]]
    @option_value = "created_at"
    @direction_value = "asc"
    render 'resources/index'
  end

  def sort_index
    @user = current_user
    @sort_options = [["Name", "name"], ["Amount", "amount"], ["Date Added", "created_at"], ["Last Updated", "updated_at"]]
    @sort_direction = [["ASC", "asc"], ["DESC", "desc"]]
    @option_value = sort_params[:attribute]
    @direction_value = sort_params[:direction]
    @all = @user.send($resource_plural).order(@option_value.to_sym => @direction_value.to_sym, name: @direction_value.to_sym).paginate(page: params[:page], per_page: 10)
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
      if @resource.type.id == 37
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
      redirect_to special_asset_step_1_url(@type.id)
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
    @page_resource.type_id = @type.id 
    if @type && ResourceName.find_by(name: $resource).resource_types.include?(@type)
      @type_category = type_category(@type)
      $resource == "Transfer" ? @form_type = "" : @form_type = "new_"
      @title_text = "New"
      set_button_text(@title_text)
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
    if $resource == "Transfer"
      @page_resource.name = "#{Asset.find(@page_resource.liquid_asset_from_id)} -> #{@type == 37 ? Asset.find_by(id: destination_id) : Debt.find_by(id: destination_id)}"
    end
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
      $resource == "Transfer" ? @form_type = "" : @form_type = "new_"
      @title_text = "New"
      set_button_text(@title_text)
      render "resources/form_page" 
    end
  end

  def edit
    @page_resource = current_user.send($resource_plural).find_by(id: params[:id])
    $resource == "Transfer" ? @form_type = "" : @form_type = "edit_"
    @title_text = "Edit"
    set_button_text(@title_text)
    render "resources/form_page" 
  end

  def update
    if @page_resource.update(resource_params)
      flash[:success] = ["#{$resource} successfully updated"]
      redirect_to "/#{$resource_plural}/#{@page_resource.id}" 
    else
      $resource == "Transfer" ? @form_type = "" : @form_type = "edit_"
      @title_text = "Edit"
      set_button_text(@title_text)
      render "resources/form_page" 
    end
  end

  def destroy
    # resource_name = @page_resource.name
    associated_transfers = associated_transfers(@page_resource.id)
    transfer_names = associated_transfers.map{|t| t.name}
    if @page_resource.destroy
      flash[:success] = ["#{$resource} deleted (#{@page_resource.name})"]
      associated_transfers.each_with_index do |t, i|
        t.destroy
        flash[:success] += ["Associated transfer deleted (#{transfer_names[i]})"]
      end

      redirect_to "/#{$resource_plural}"
    end
  end

  private

    # CHANGE TO INDIVIDUAL CONTROLLERS
    def resource_params
      params.require($resource.downcase.to_sym).permit(input_fields($new_resource).map{|pi| pi.to_sym})
      # MAY WORK WITHOUT ".to_sym" METHOD
    end

    def sort_params
      params.permit(:attribute, :direction)
    end

    def access_granted
      redirect_to login_url if !logged_in?
    end

    def correct_user
      @page_resource = $resource.constantize.find_by(id: params[:id])
      if !(@page_resource.user ==  current_user)
        flash[:error] = ["Invalid User"]
        redirect_to root_url
      end
    end

    def set_button_text(form_type)
      case form_type
      when "New"
        @button_text = "Add #{$resource}"
      when "Edit"
        @button_text = "Update #{$resource}"
      end
    end

    def associated_transfers(resource_id)
      if $resource == "Asset"
        transfers_a = Transfer.where(liquid_asset_from_id: resource_id)
        transfers_b = Transfer.where(type_id: 37).where(destination_id: resource_id)
        transfers_a + transfers_b
      elsif $resource == "Debt"
        Transfer.where(type_id: 38).where(destination_id: resource_id)
      else
        []
      end
    end

end

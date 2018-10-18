class UsersController < ApplicationController
  
  before_action :logged_out_redirect, :set_user, only: [:edit, :update, :destroy]
  # before_action :set_user, only: [:show, :edit, :destroy]
  

  def show
    if logged_in?
      set_user
    else
      render "static_pages/logged_out_home"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = ["Please check your e-mail for a link to activate your account"]
      redirect_to root_url
    else
      # @user.errors.full_messages.each do |message|
      #   flash[:error] += message 
      # end
      render 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = ["Account successfully updated"]
      redirect_to root_path
    else
      render "edit"
    end
  end

  def destroy

  end

  private 
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :birthday, :password, :password_confirmation)
    end

    def set_user
      @user = current_user
    end

    def logged_out_redirect
      if !logged_in?
        redirect_to login_path
      end
    end

end

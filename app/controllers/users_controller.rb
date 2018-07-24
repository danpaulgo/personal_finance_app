class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    if !logged_in?
      render 'static_pages/logged_out_home'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.assets.create(type_id: 1, name: "Cash on Hand", amount: 0.0, liquid: true, primary: true)
      @user.assets.create(type_id: 2, name: "Checking Account", amount: 0.0, liquid: true, primary: true)
      flash[:success] = ["User successfully created"]
      redirect_to login_path
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

  end

  def destroy

  end

  private 
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = current_user
    end

end

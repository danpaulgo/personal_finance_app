class UsersController < ApplicationController
  
  def show
    if logged_in?
      @user = current_user
      # @future_net_worth = FutureNetWorth.new
    else
      redirect_to login_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.assets.create(name: "Cash", amount: 0.0, primary: true, liquid: true)
      @user.assets.create(name: "Checking Account", amount: 0.0, primary: true, liquid: true)
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
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
      params.require(:user).permit(:username, :name, :password, :password_confirmation)
    end

end

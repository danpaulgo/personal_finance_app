class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && !!@user.authenticate(params[:session][:password])
      login(@user)
      remember(@user)
      redirect_to root_path
    else 
      flash[:error] = ["Incorrect email/password"]
      render 'new'
    end
  end

  # def new_create
  #   @user = User.find_by(email: params[:session][:email])
  #   remember = params[:session][:remember]
  #   if @user && !!@user.authenticate(params[:session][:password])
  #     if remember
  #       cookies.permanent[:remember_token] = remember_token 
  #       cookies.permanent.signed[:user_id]
  #     else
  #       session[:id] = @user.id
  #     end
  #     redirect_to root_path
  #   else
  #     flash[:error] = ["Incorrect email/password"]
  #     render 'new'
  #   end
  # end

  def destroy
    logout
    redirect_to root_path
  end

  def invalid
    redirect_to root_path
  end

end

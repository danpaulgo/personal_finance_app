class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    if @user && !!@user.authenticate(params[:session][:password])
      session[:id] = @user.id
      redirect_to root_path
    else 
      flash[:error] = ["Incorrect username/password"]
      render 'new'
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def invalid
    redirect_to root_path
  end

end

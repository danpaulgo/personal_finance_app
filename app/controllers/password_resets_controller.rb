class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = ["Email sent with password reset instructions"]
      redirect_to root_url
    else
      flash[:error] = ["There is no associated with that e-mail address"]
      render 'new'
    end
  end

  def edit

  end

  def update

  end

end

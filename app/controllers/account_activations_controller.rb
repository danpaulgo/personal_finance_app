class AccountActivationsController < ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      @user.assets.create(type_id: 1, name: "Cash on Hand", amount: 0.0, liquid: true, primary: true)
      @user.assets.create(type_id: 2, name: "Checking Account", amount: 0.0, liquid: true, primary: true)
      flash[:success] = ["Account activated!"]
      redirect_to login_url
    else
      flash[:error] = ["Invalid activation link"]
      logout
      redirect_to root_url
    end
  end

end

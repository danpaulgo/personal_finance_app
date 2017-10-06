class FutureNetWorthsController < ApplicationController
  include SessionsHelper
  include UsersHelper

  def create
    @user = current_user
    time_now = Time.now.to_date
    date = future_date_param.to_date
    if time_now > date
      flash[:error] = ["Must enter valid date in future"]
      redirect_to root_path
    else
      @user.future_net_worth = @user.calculate_future_net_worth(future_date_param)
      render 'users/show'
    end
  end

  private
    
    def future_date_param
      params.permit(:date)[:date]
    end

end

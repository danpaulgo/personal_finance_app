class FutureNetWorthsController < ApplicationController
  include SessionsHelper
  include UsersHelper

  def create
    @user = current_user
    @user.future_net_worth = calculate_future_net_worth(@user, future_date_param)
    render 'users/show'
  end

  private
    
    def future_date_param
      params.permit(:date)[:date]
    end

end

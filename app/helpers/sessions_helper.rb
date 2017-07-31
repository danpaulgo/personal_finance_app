module SessionsHelper

  def logged_in?
    !!session[:id] if session
  end

  def current_user
    User.find_by(id: session[:id])
  end

end

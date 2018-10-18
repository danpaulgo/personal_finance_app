module SessionsHelper

  def logged_in?
    !!session[:user_id] if session
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    # binding.pry
    if logged_in?
      forget(current_user)
      session[:user_id] = nil  
      @current_user = nil
    end
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token 
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end

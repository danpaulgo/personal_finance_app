class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def design_test
    render "/DESIGN.html.erb"
  end

end

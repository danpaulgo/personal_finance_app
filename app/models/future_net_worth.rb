class FutureNetWorth
  # binding.pry
  require 'sessions_helper.rb'
  include SessionsHelper
  
  attr_accessor :date, :user

  def model_name
    ActiveModel::Name.new(FutureNetWorth)
  end

  def to_key
    
  end

end


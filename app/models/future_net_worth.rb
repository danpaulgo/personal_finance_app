class FutureNetWorth
  # binding.pry
  require 'sessions_helper.rb'
  include SessionsHelper
  
  attr_accessor :date, :user

  def def date=(date)
    @date = date
  end

  def date
    @date
  end

  def model_name
    ActiveModel::Name.new(FutureNetWorth)
  end

  def to_key
    
  end

end


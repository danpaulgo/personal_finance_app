class IntroQuizController < ApplicationController

  class << self
    attr_accessor :property_number, :vehicle_number
  end

  @@property_number = 0
  @@vehicle_number = 0

  def step_one
    # Do you rent or own or rent
    render 'intro_quiz/step_one.html.erb'
  end

  def process_step_one
    binding.pry
    if params[:own]
      @@property_number +=1
      redirect_to iq_step_four_path
    else
      redirect_to iq_step_two_path
    end
  end

  def step_two
    # Are utilities included?
  end

  def step_three
    # How much do you pay for rent in a month
    # Render utilities questions if utilities are not included
  end

  def step_four
    # recreate first step of property form, saving property inside session[:"property_#{@property_number}"]
  end

  def step_n

  end

  def process_step_n
    if params[:add_property]
      @property_number +=1
      redirect_to iq_step_four_path
    else
      # move on to vehicles
    end
  end

end

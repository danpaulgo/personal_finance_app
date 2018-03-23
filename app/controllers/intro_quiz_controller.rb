class IntroQuizController < ApplicationController

  class << self
    attr_accessor :property_number, :vehicle_number
  end

  @@property_number = 0
  @@vehicle_number = 0

  def render_step(n)
    render "intro_quiz/step_#{n}.html.erb"
  end

  def validate_step(step_params, step_number)
    step_object = "IntroQuizSteps::Step#{step_number.capitalize}".constantize.new(step_params)
    step_object.valid?
  end

  def step_one
    # Do you rent or own or rent
    @page_resource = IntroQuizSteps::StepOne.new
    render_step(:one)
  end

  # Try and clean this up
  def process_step_one
    step_number = __method__.to_s.split("_").last
    if params[:intro_quiz_steps_step_one].nil?
      flash[:error] = ["Form cannot be left blank"]
      @page_resource = "IntroQuizSteps::Step#{step_number.capitalize}".constantize.new
      render_step(:one)
    else
      step_params = params.require(:intro_quiz_steps_step_one).permit(:own)
      @page_resource = "IntroQuizSteps::Step#{step_number.capitalize}".constantize.new(step_params)
      if !@page_resource.valid?
        render_step(:one)
      else
        if @page_resource.own
          @@property_number +=1
          redirect_to iq_step_four_path
        else
          redirect_to iq_step_two_path
        end
      end
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

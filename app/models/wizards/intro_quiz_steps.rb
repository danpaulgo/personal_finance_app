module IntroQuizSteps

  class Base
    include ActiveModel::Model
  end

  class StepOne < Base

    attr_accessor :own

    validates :own, presence: true

  end

end
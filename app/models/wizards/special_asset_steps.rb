module SpecialAssetSteps

  class Base
    include ActiveModel::Model
  end

  class StepOneVehicle < Base

    attr_accessor :name, :amount, :financed 

    validates :name, :amount, :financed, presence: true

  end

  class StepOneProperty < StepOneVehicle

    attr_accessor :location, :income

    validates :income, presence: true

  end

  # Loan Details
  class StepTwo < Base

    attr_accessor :amount, :interest, :compound_frequency
    
    validates :amount, :interest, :compound_frequency, presence: true

  end

  # Loan Payment Details
  class StepThree < Base

    attr_accessor :amount, :frequency, :paid_using, :next_date, :end_date

    validates :amount, :frequency, :paid_using, :next_date, presence: true

  end


end
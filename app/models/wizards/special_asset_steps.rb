module SpecialAssetSteps

  class Base
    include ActiveModel::Model
  end

  class Step1Vehicle < Base

    attr_accessor :name, :amount, :financed 

    validates :name, :amount, :financed, presence: true

  end

  class Step1Property < Step1Vehicle

    attr_accessor :location, :income

    validates :income, presence: true

  end

  # Loan Details
  class Step2 < Base

    attr_accessor :amount, :interest, :compound_frequency
    
    validates :amount, :interest, :compound_frequency, presence: true

  end

  # Loan Payment Details
  class Step3 < Base

    attr_accessor :amount, :frequency, :paid_using, :next_date, :end_date

    validates :amount, :frequency, :paid_using, :next_date, presence: true

  end

  class Step4 < Base

    attr_accessor :average_rate, :custom_rate

  end


end
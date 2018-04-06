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

  class SteoTwo < Base

    attr_accessor :mortgage_amount, :mortgage_interest, :mortgage_compound_frequency, :payment_amount, :payment_frequency, :next_payment_date, :paid_using

    validates :mortgage_amount, :mortgage_interest, :mortgage_compound_frequency, :payment_amount, :payment_frequency, :next_payment_date, :paid_using, presence: true

  end

end
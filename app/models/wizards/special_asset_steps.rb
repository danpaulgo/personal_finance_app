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

    # attr_accessor :

  end

end
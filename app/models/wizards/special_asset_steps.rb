module SpecialAssetSteps

  class Base
    
    include ActiveModel::Model

    def all_attributes
      attrs = []
      methods.each do |var|
        str = var.to_s.gsub /^@/, ''
        if respond_to? "#{str}=" 
          attrs.push str.to_sym if str.match /\A\w/
        end
      end
      attrs
    end
  
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

    validate :average_or_custom

    def average_or_custom
      errors.add(:base, "Form may not be left blank") if average_rate.blank? && custom_rate.blank?
    end

  end

  class Step5 < Base 

    attr_accessor :insurance, :maintenance, :miscellaneous
    
    validate :both_or_neither

    def both_or_neither
      all_attributes.each do |attribute|
        amount = send(attribute)[:amount] if !send(attribute).blank?
        paid_using = send(attribute)[:paid_using] if !send(attribute).blank?
        if (amount.blank? && !paid_using.blank?) || (!amount.blank? && paid_using.blank?)
          errors.add("#{attribute}:", "Must answer both parts of question or leave completely blank")
        end
      end
    end

  end

  class Step5Vehicle < Step5

    attr_accessor :gasoline

  end

  class Step5Property < Step5

    attr_accessor :tax, :utilities, :income

  end


end
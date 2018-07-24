class Asset < ApplicationRecord

  belongs_to :user

  validates :type_id, :name, :amount, :user_id, :presence => true
  validates_inclusion_of :liquid, :primary ,:in => [true, false]
  validates_presence_of :compound_frequency, if: :interest?

  def type
    ResourceType.find(self.type_id)
  end

  def to_s
    name
  end

end

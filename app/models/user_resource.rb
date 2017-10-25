class UserResource < ApplicationRecord

  belongs_to :user

  def type
    ResourceType.find(self.type_id)
  end

end
class Group < ActiveRecord::Base
  attr_accessible :membership_state, :name, :user_id
  
  belongs_to :user
  validates :user_id, presence: true
end

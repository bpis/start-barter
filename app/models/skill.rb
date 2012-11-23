class Skill < ActiveRecord::Base
  attr_accessible :proficiency, :skill_name, :user_id, :visibility
  belongs_to :user
  
  validates :user_id, presence: true
end

class Skill < ActiveRecord::Base
  attr_accessible :proficiency, :skill_name, :user_id, :visibility
  belongs_to :user
end

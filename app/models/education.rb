class Education < ActiveRecord::Base
  attr_accessible :activities, :end_date, :field_of_study, :grade, :notes, :school_name, :start_date, :degree, :user_id
  belongs_to :user
  
  validates :user_id, presence: true
end

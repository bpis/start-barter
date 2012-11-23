class Profile < ActiveRecord::Base
  attr_accessible :address_line_1, :address_line_2, :city, :company_name, :github_profile_link, :job_profile, :keyword, :overview, :phone_no, :state, :tagline, :user_id, :zip
  belongs_to :user
  validates :user_id, presence: true
end

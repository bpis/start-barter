class Country < ActiveRecord::Base
  attr_accessible :code, :name
  #belongs_to :user
  has_many :users
end

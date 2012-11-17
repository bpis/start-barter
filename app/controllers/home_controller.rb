class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
  
  def index
    #@user = current_user
    @users = User.all
  end
  
  # def recommend_user
    # @users = User.recommend_user(params[:user])
  # end
end

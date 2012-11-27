class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    #@user = current_user
    @users = User.all
    @skills = Skill.all
    user = current_user
  end

  def new_profile
    @profile = current_user.profile
  end

  def profile
    @user = current_user
    @profile = current_user.profile
    if @profile.present?
      if @user.profile.update_attributes(params[:profile])
        flash[:notice] = "Profile saved successfully."
        redirect_to "/"
      else
        flash[:error] = "Something went wrong."
        redirect_to :back
      end
    end
  end

  def edit_user_info
    @user_fname_lname = current_user

  # respond_to do |format|
  # format.js
  # end

  end

  def update_user_info
    @user = current_user.update_attributes(params[:user])
    
    respond_to do |format|
      format.js
    end
    
  end

end

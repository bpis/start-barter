class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    #@user = current_user
    @users = User.all
    @skills = Skill.all
    @experiences = Experience.all
    @educations = Education.all
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
    @profile = current_user.profile
  end

  def update_user_info
    
    if params[:user]
      @user = current_user.update_attributes(params[:user])
    end  
    if params[:profile]
      @profile_overview = current_user.profile.update_attributes(params[:profile])
    end
   
    if params[:skill] && params[:id]
      @skill = current_user.skills.find(params[:id])
       #@skill.update_attributes(:name => params[:skill][:name], :proficiency => params[:skill][:proficiency])
       @skill.update_attributes(params[:skill])
    end
    
    if params[:experience] && params[:id]
      @experience = current_user.experiences.find(params[:id])
      @experience.update_attributes(params[:experience]) 
    end
    
    if params[:education] && params[:id]
      @education = current_user.educations.find(params[:id])
       @education.update_attributes(params[:education])
    end
    respond_to do |format|
      format.js
    end
    
  end
end

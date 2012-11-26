class Users::RegistrationsController < Devise::RegistrationsController
  # def edit
    # @user = current_user
  # end  
  # def update
    # @user = User.find(current_user)
    # #debugger
    # if @user.update_attributes(params[:user])
      # sign_in @user, :bypass => true
      # redirect_to :back
    # else
      # render "edit"
    # end
  # end
end
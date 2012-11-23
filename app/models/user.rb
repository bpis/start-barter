class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :login
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :username, :company_name, :country_id, :provider, :uid, :about_me, :dob, :hometown, :location, :relationships, :status, :gender, :organisation, :designation, :profession, :facebook_url, :educational_details, :facebook_image, :iam, :iamlookingfor, :profile_picture
  
  after_create :create_user_profile
  after_create :create_user_skills
  
  # accepts_nested_attributes_for :profile
  # accepts_nested_attributes_for :skills
  
  has_one :profile
  has_many :skills
  belongs_to :country
  
  mount_uploader :profile_picture, ProfilePictureUploader
  #has_one :country
  # attr_accessible :title, :body
  #validations
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true
  #validates :country_id, :presence => true











    # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address 
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end


  #def self.find_for_authentication(conditions)
   # login = conditions.delete(:login)
   # where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  #end
  # def linkedin
    # omniauth_hash = env["omniauth.auth"]
    # current_user.create_linkedin_connection(
      # :token  => omniauth_hash["extra"]["access_token"].token,
      # :secret => omniauth_hash["extra"]["access_token"].secret,
      # :uid    => omniauth_hash["uid"]
    # )
    # redirect_to root_path, :notice => "You've successfully connected your LinkedIn account."
  # end


#for facebook integration with omniauth
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.new(username:auth.extra.raw_info.name.present? ? auth.extra.raw_info.name : "",
                      first_name:auth.extra.raw_info.first_name.present? ? auth.extra.raw_info.first_name : "",
                      last_name:auth.extra.raw_info.last_name.present? ? auth.extra.raw_info.last_name : "",
                      provider:auth.provider.present? ? auth.provider : "",
                      uid:auth.uid.present? ? auth.uid : "",
                      email:auth.info.email,
                      password:Devise.friendly_token[0,20],
                      about_me:auth.extra.raw_info.bio.present? ? auth.extra.raw_info.bio : "",
                      dob:auth.extra.raw_info.birthday.present? ? auth.extra.raw_info.birthday : "",
                      hometown:auth.extra.raw_info.hometown.present? && auth.extra.raw_info.hometown.name.present? ? auth.extra.raw_info.hometown.name : "",
                      location:auth.extra.raw_info.location.present? && auth.extra.raw_info.location.name.present? ? auth.extra.raw_info.location.name : "",
                      relationships:auth.extra.raw_info.relationship_status.present? ? auth.extra.raw_info.relationship_status : "",
                      gender:auth.extra.raw_info.gender.present? ? auth.extra.raw_info.gender : "",
                      organisation:auth.extra.raw_info.work.present? && auth.extra.raw_info.work[0].employer.present? ?  auth.extra.raw_info.work[0].employer.name : "",
                      designation:auth.extra.raw_info.work.present? && auth.extra.raw_info.work[0].position.present? ? auth.extra.raw_info.work[0].position.name : "",
                      facebook_url:auth.info.urls.Facebook.present? ? auth.info.urls.Facebook : "" ,
                      educational_details:auth.extra.raw_info.education.present? ? auth.extra.raw_info.education[1].school.name : "" ,
                      facebook_image:auth.info.image.present? ? auth.info.image : ""
                      )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    # unless user
      # user = User.new(:token  => omniauth_hash["extra"]["access_token"].token,
                      # :secret => omniauth_hash["extra"]["access_token"].secret,
                      # :uid    => omniauth_hash["uid"])
      # redirect_to root_path, :notice => "You've successfully connected your LinkedIn account."
      # user.skip_confirmation!
      # user.save!
    # end
    # user
    #debugger
    unless user                      
        user = User.new(username:auth.info.name.present? ? auth.info.name : "",
                      first_name:auth.extra.raw_info.firstName.present? ? auth.extra.raw_info.firstName : "",
                      last_name:auth.extra.raw_info.lastName.present? ? auth.extra.raw_info.lastName : "",
                      provider:auth.provider.present? ? auth.provider :  "",
                      uid: auth.uid.present? ? auth.uid : "",
                      email: auth.extra.raw_info.emailAddress.present? ? auth.extra.raw_info.emailAddress : "",
                      password:Devise.friendly_token[0,20],
                      company_name:auth.extra.raw_info.industry.present? ? auth.extra.raw_info.industry : "",
                      hometown:auth.extra.raw_info.location.name.present? ? auth.extra.raw_info.location.name : "",
                      about_me:auth.extra.raw_info.headline.present? ? auth.extra.raw_info.headline : "",
                      location:auth.extra.raw_info.location.name.present? ? auth.extra.raw_info.location.name : "",                      
                      organisation:auth.extra.raw_info.industry.present? ? auth.extra.raw_info.industry : "",   
                      designation:auth.extra.raw_info.headline.present? ? auth.extra.raw_info.headline : "",
                         facebook_url:auth.extra.raw_info.publicProfileUrl.present? ? auth.extra.raw_info.publicProfileUrl : "",
                      
                      )        
      user.skip_confirmation!
      user.save!
    end
    user
    
    
  end
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

private
  
  def create_user_profile
   @profile = self.create_profile
   #self.build_profile
  end 
  
  def create_user_skills
    @skill = self.skills.build
  end
end

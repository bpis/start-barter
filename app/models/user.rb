class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessor :password, :password_confirmation, :current_password
  attr_accessor :login
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :username, :company_name, :country_id, :provider, :uid, :about_me, :dob, :hometown, :location, :relationships, :status, :gender, :organisation, :designation, :profession, :facebook_url, :educational_details, :facebook_image, :iam, :iamlookingfor, :profile_picture, :profile_attributes
  #attr_accessible :current_password, :profile
  
  #callback methods
  after_create :create_user_profile
  after_create :create_user_skills, :unless => :check_provider?
  after_create :create_user_experiences, :unless => :check_provider?
  after_create :create_user_educations, :unless => :check_provider?
  after_create :create_user_groups, :unless => :check_provider?
  # Associations
  has_one :profile
  has_many :skills
  has_many :experiences
  has_many :educations
  has_many :groups
  belongs_to :country
  
  #Image Uploader
  mount_uploader :profile_picture, ProfilePictureUploader
  
  # Nested attributes
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :skills
  accepts_nested_attributes_for :experiences
  accepts_nested_attributes_for :educations
  accepts_nested_attributes_for :groups
  

  #validations
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true
  #validates :country_id, :presence => true



  # bypasses Devise's requirement to re-enter current password to edit
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
      update_attributes(params) 
  end
  # def update_without_password(params={})
    # params.delete(:password)
    # super(params)
  # end
  
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
                      profile_picture:auth.info.image.present? ? auth.info.image : "",
                      facebook_image:auth.info.image.present? ? auth.info.image : "" 
                      )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  # For Linkedin Authentication with omniauth - Linkedin
  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user    
        dob = []
        if auth.extra.raw_info.dateOfBirth.present?
          dob << auth.extra.raw_info.dateOfBirth.day
          dob << auth.extra.raw_info.dateOfBirth.month
          dob << auth.extra.raw_info.dateOfBirth.year
        end        
        user = User.new(username:auth.info.name.present? ? auth.info.name : "",
                        first_name:auth.extra.raw_info.firstName.present? ? auth.extra.raw_info.firstName : "",
                        last_name:auth.extra.raw_info.lastName.present? ? auth.extra.raw_info.lastName : "",
                        provider:auth.provider.present? ? auth.provider :  "",
                        uid: auth.uid.present? ? auth.uid : "",
                        email: auth.extra.raw_info.emailAddress.present? ? auth.extra.raw_info.emailAddress : "",
                        password:Devise.friendly_token[0,20],
                        company_name:auth.extra.raw_info.industry.present? ? auth.extra.raw_info.industry : "",
                        hometown:auth.extra.raw_info.location.name.present? ? auth.extra.raw_info.location.name : "",
                        location:auth.extra.raw_info.location.name.present? ? auth.extra.raw_info.location.name : "",                      
                        dob:dob.join("-"),            
                        organisation:auth.extra.raw_info.industry.present? ? auth.extra.raw_info.industry : "",   
                        designation:auth.extra.raw_info.headline.present? ? auth.extra.raw_info.headline : "",
                        facebook_url:auth.extra.raw_info.publicProfileUrl.present? ? auth.extra.raw_info.publicProfileUrl : "",
                        profile_picture:auth.extra.raw_info.pictureUrl.present? ? auth.extra.raw_info.pictureUrl : "",  
                        facebook_image:auth.extra.raw_info.pictureUrl.present? ? auth.extra.raw_info.pictureUrl : "", 
                      )
                             
        user.skip_confirmation!
        user.save!
        user_profile =  user.profile.update_attributes(
                              company_name:auth.extra.raw_info.industry.present? ? auth.extra.raw_info.industry : "",
                              tagline:auth.extra.raw_info.headline.present? ? auth.extra.raw_info.headline : "",
                              overview:auth.extra.raw_info.summary.present? ? auth.extra.raw_info.summary : "",
                              phone_no:auth.extra.raw_info.phoneNumbers.values[1].first.phoneNumber.present? ? auth.extra.raw_info.phoneNumbers.values[1].first.phoneNumber : "",
                              address_line_1:auth.extra.raw_info.mainAddress.present? ? auth.extra.raw_info.mainAddress : "",
                              address_line_2:auth.extra.raw_info.mainAddress.present? ? auth.extra.raw_info.mainAddress : ""
                              )
        
        user_skills = auth.extra.raw_info.skills.values[1]
        if auth.extra.raw_info.skills.values[1].present?
          user_skills.each do |s|
            u = user.skills.build(name:s.skill.name, user_id:user.id)
          end
        end
        
        user_experiences = auth.extra.raw_info.positions.values[1]
        if auth.extra.raw_info.positions.values[1].present?   
          user_experiences.each do |e|
            sd = []
            ed = []
            if e.startDate.present?
              sd << e.startDate.month
              sd << e.startDate.year
              end  
            if e.endDate.present?
              ed << e.endDate.month 
              ed << e.endDate.year
            end 
            ue = user.experiences.build(company_name:e.company.name, title:e.title, is_current:e.isCurrent, description:e.summary, start_date:sd.join("-"), end_date:ed.join("-"), location:auth.extra.raw_info.location.name, user_id:user.id)
          end
        end
      
        user_educations = auth.extra.raw_info.educations.values[1]
        if auth.extra.raw_info.educations.values[1].present?          
          user_educations.each do |edu|
            ued = user.educations.build(school_name:edu.schoolName, field_of_study:edu.fieldOfStudy, start_date:edu.startDate.year, end_date:edu.endDate.year, activities:edu.activities, notes:edu.notes, degree:edu.degree)
          end       
        end
        
        #user_groups = auth.extra.raw_info.groupMemberships.values[1]
        #if auth.extra.raw_info.groupMemberships.values[1].present?
          #user_groups.each do |grp|
            #ugroup = user.groups.build(name:grp.group.name, membership_state:grp.membershipState.code)
          #end
        #end
    end
    user
  end
  
  # Devise Method
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

private
  
  def create_user_profile
    self.create_profile
  end 
  
  def create_user_skills
   self.skills.create
  end
  
  def create_user_experiences
    self.experiences.create
  end
  
  def create_user_educations
    self.educations.create
  end
  
  def create_user_groups
    self.groups.create
  end
  
  def check_provider? 
    self.provider.present?
  end
end

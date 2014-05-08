# /app/models/user.rb
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one :student, dependent: :destroy
  has_one :tutor, dependent: :destroy

  accepts_nested_attributes_for :student, update_only: true
  accepts_nested_attributes_for :tutor, update_only: true

  acts_as_messageable

  class << self
    def find_for_facebook_oauth(auth)
      student = where(auth.slice(:provider, :uid)).first_or_create do |user|
                  user.provider = auth.provider
                  user.uid = auth.uid
                  user.email = auth.info.email
                  user.password = Devise.friendly_token[0, 20]
                end
      student.skip_confirmation!
      Student.find_or_create_by(username: auth.info.name) do |u|
        u.user = student
      end
    end
  end

  # def name
  #   display_name
  # end

  def mailboxer_email(object)
    email
  end

  def name
    # tutor && tutor.name ||
    #   student && student.username ||
    #   email
    email
  end

  def timezone
    tutor && tutor.time_zone ||
      student && student.time_zone
  end

  def type
    role.class.to_s.downcase.to_sym if role
  end

  def student?
    type == :student
  end

  def tutor?
    type == :tutor
  end

  def role
    tutor || student
  end

  def avatar
    if role.respond_to?(:avatar_url) && role.avatar_url.present?
      role.avatar_url
    else
      default_avatar
    end
  end

  def default_avatar
    'avatar-default.png'
  end

  def presence_info
    base_attrs = {
      name: name
    }
    base_attrs.merge!(tutor.attrs) if tutor
    base_attrs.merge!(student.attrs) if student
    base_attrs
  end
end

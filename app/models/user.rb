# /app/models/user.rb
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :student, dependent: :destroy
  has_one :tutor, dependent: :destroy

  accepts_nested_attributes_for :student, update_only: true
  accepts_nested_attributes_for :tutor, update_only: true

  def display_name
    tutor && tutor.name ||
      student && student.username ||
      email
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
      name: display_name
    }
    base_attrs.merge!(tutor.attrs) if tutor
    base_attrs.merge!(student.attrs) if student
    base_attrs
  end
end

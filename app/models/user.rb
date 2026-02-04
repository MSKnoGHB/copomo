class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :user_image

  has_many :room_accesses, dependent: :destroy
  has_many :chat_logs, dependent: :destroy
  has_many :study_records, dependent: :destroy
  has_many :study_themes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
 
  validates :name, presence: true, uniqueness: true

  
end

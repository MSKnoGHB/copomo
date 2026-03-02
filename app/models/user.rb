class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :room_accesses, dependent: :destroy
  has_many :chat_logs, dependent: :destroy
  has_many :study_records, dependent: :destroy
  has_many :study_themes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  
  has_one_attached :user_image
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 20}

  def get_image
    unless user_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      user_image.attach(
        io: File.open(file_path),
        filename: 'default-image.jpg',
        content_type: 'image/jpeg'
      )
    end
    user_image
  end


  
end

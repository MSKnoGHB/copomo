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
  
  NAME_MAX_LENGTH = 20
  validates :name, presence: true, uniqueness: true, length: { maximum: NAME_MAX_LENGTH}

  #Activestorage
  def get_image_resize
    if user_image.attached?
      bucket_name = "copomo-img-files-resize"
      region = "ap-northeast-1"
      key = user_image.key
      extension = user_image.content_type.split('/').pop
      "https://#{bucket_name}.s3-#{region}.amazonaws.com/#{key}-thumbnail.#{extension}"
    else
      ActionController::Base.helpers.asset_path('no_image.jpg')
    end
  end

  #検索機能
  def self.search_for(content, method)
    active_study_records = StudyRecord.where(is_publish: true).joins(:user)
    if method == "perfect"
      active_study_records.where(users: { name: content })
    elsif method == "forward"
      active_study_records.where("users.name LIKE ?", content + "%")
    elsif method == "backward"
      active_study_records.where("users.name LIKE ?", "%" + content)
    else
      active_study_records.where("users.name LIKE ?", "%"+ content + "%")
    end
  end

  #学習終了退出機能
  def complete_study_session!(study_record_id, room_access_id, exit_type: 0)
    study_record = self.study_records.find(study_record_id)
    if study_record.room.timer_status[:mode] == "集中" && study_record.study_intervals.exists?(ended_at: nil)
      study_interval = study_record.study_intervals.find_by(ended_at: nil) 
      study_interval.update!(ended_at: Time.current)
      Rails.logger.info "study_interval changes: #{study_interval.saved_changes}"
    end

    #study_intervalの学習時間の合計処理
    study_intervals = study_record.study_intervals
    total_seconds = 0
    total_minutes = 0
    study_intervals.each do |interval|
      total_seconds += interval.ended_at - interval.started_at
    end
    total_minutes += (total_seconds / 60)

    #study_recordの更新
    study_record.update!(
      ended_at: Time.current,
      total_focus_minutes: total_minutes
    ) 
    Rails.logger.info "study_record changes: #{study_record.saved_changes}"

    #room_accessの更新
    room_access = self.room_accesses.find(room_access_id)
    room_access.update!(
      exit_time: Time.current,
      study_status: "finished",
      is_active: false,
      exit_type: exit_type
    )
    Rails.logger.info "room_access changes: #{room_access.saved_changes}"

    study_record  
  end
  
  def self.guest
    random_value = SecureRandom.hex(4)
    create!(email: "guest_#{random_value}@example.com") do |user|
      user.password = SecureRandom.hex(10)
      user.name = "guest_#{random_value}" 
    end
  end

  def guest_user?
    email.start_with?("guest_") && email.end_with?("@example.com")
  end

end


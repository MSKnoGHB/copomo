class StudyRecord < ApplicationRecord
  has_many :study_intervals, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :room
  belongs_to :study_theme
  
  validates :record_body, length: { maximum: 500 }

  def self.search_for(content, method)
    active_study_records = StudyRecord.where(is_publish: true).joins(:study_theme)
    if method == "perfect"
      active_study_records.where("study_themes.theme_title = ?", content)
    elsif method == "forward"
      active_study_records.where("study_themes.theme_title LIKE ?", content + '%')
    elsif method == "backward"
      active_study_records.where("study_themes.theme_title LIKE ?", '%' + content)
    else
      active_study_records.where("study_themes.theme_title LIKE ?", '%' + content + '%')
    end
  end

  def likes_by?(user)
    likes.exists?(user_id: user.id)
  end

end

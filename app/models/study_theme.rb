class StudyTheme < ApplicationRecord
  has_many :room_accesses
  has_many :study_records
  belongs_to :user
  belongs_to :study_category

  validates :theme_title, presence: true, uniqueness:{ scope: :user_id }, length: { maximum: 20 }
  validates :theme_body, length: { maximum: 100 }

  enum theme_color: {
    red:    0, 
    orange: 1, 
    yellow: 2, 
    green:  3, 
    blue:   4, 
    purple: 5, 
    pink:   6, 
    brown:  7, 
    black:  8
  }

  COLOR_MAP = {
    "red"    => "#ff4d4d",
    "orange" => "#ffa500",
    "yellow" => "#ffff00",
    "green"  => "#2ecc71",
    "blue"   => "#3498db",
    "purple" => "#9b59b6",
    "pink"   => "#ff69b4",
    "brown"  => "#8b4513",
    "black"  => "#333333"
  }
  
end

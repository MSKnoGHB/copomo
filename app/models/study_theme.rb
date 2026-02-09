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

end

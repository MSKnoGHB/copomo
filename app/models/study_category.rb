class StudyCategory < ApplicationRecord
  has_many :study_themes, dependent: :destroy

  validates :category_title, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :category_body, length: { maximum: 100 }
end

class StudyRecord < ApplicationRecord
  has_many :study_intervals, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :room
  belongs_to :study_theme
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :study_record

  COMMENT_MAX_LENGTH = 250
  validates :comment_body, presence: true, length: { maximum: COMMENT_MAX_LENGTH }
end

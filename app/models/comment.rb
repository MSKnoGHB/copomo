class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :study_record

  validates :comment_body, presence: true, length: { maximum: 250 }
end

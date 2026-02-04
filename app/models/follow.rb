class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  validates :followee_id, uniqueness: { scope: :follower_id }
end

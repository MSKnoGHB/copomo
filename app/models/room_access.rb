class RoomAccess < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :study_theme
end

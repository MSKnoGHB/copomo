class RoomAccess < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :study_theme

  enum study_status: {
    waiting:  0,
    studying: 1,
    paused:   2,
    finished: 3
  }

end

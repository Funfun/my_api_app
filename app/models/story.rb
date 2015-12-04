class Story < ActiveRecord::Base
  module STATUS
    PENDING = 1
    IN_PROGRESS = 2
    COMPLETE = 3
  end

  belongs_to :epic
  belongs_to :user

  before_create :set_initial_status

  private

  def set_initial_status
    self.status = STATUS::PENDING
  end
end

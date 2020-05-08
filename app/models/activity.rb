class Activity < ApplicationRecord
  belongs_to :excavation

  #def initialize(options = {})
    # This had to be changed for the last tests added in "costs".

    # @completed = options[:completed]

  #  mark_as_completed(options[:completed]) if options[:completed]
  #  @cost = options[:cost]
  #end

  def mark_as_completed(date = Time.current)
    #date = Time.current if date == true

    # It's no longer enough to just say that an activity is marked as being
    # complete. Now there will be a datetime associated with that.

    # @completed = true

    self.completed = date
  end

  def complete?
    completed.present?
  end

  def part_of_pace?
    return false unless complete?
    completed > Excavation.work_interval_in_days.days.ago
  end

  def counts_towards_pace
    part_of_pace? ? cost : 0
  end
end

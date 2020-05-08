class Activity
  attr_accessor :cost, :completed

  def initialize(options = {})
    @completed = options[:completed]
    @cost = options[:cost]
  end

  def mark_as_completed(date = Time.current)
    # It's no longer enough to just say that an activity is marked as being
    # complete. Now there will be a datetime associated with that.

    # @completed = true

    @completed = date
  end

  def complete?
    completed
  end

  def part_of_pace?
    return false unless complete?
    completed > 14.days.ago
  end

  def counts_towards_pace
    0
  end
end

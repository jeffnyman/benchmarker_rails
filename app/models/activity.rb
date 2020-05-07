class Activity
  attr_accessor :cost, :completed

  def initialize(options = {})
    @completed = options[:completed]
    @cost = options[:cost]
  end

  def mark_as_completed
    @completed = true
  end

  def complete?
    completed
  end
end

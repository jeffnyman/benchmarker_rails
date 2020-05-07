class Activity
  def initialize
    @completed = false
  end

  def mark_as_completed
    @completed = true
  end

  def complete?
    @completed
  end
end

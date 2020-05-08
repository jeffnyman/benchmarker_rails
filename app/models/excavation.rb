class Excavation
  attr_accessor :activities

  def initialize
    @activities = []
  end

  def finished?
    # It's no longer good enough to check if the activities are empty (as in
    # there are none) because now activities may be present (which would
    # normally mean the excavation is unfinished) but they may completed
    # (which means the excavation is finished).

    # activities.empty?

    # Now instead of iterating over the activities to check if they are
    # complete, I can make this a bit more expressive by saying what I
    # am actually looking for.

    # activities.all?(&:complete?)

    incomplete_activities.empty?
  end

  def total_cost
    activities.sum(&:cost)
  end

  def remaining_cost
    incomplete_activities.sum(&:cost)
  end

  def incomplete_activities
    activities.reject(&:complete?)
  end

  def completed_pace
    activities.sum(&:counts_towards_pace)
  end

  def current_pace
    completed_pace * 1.0 / 14
  end

  def projected_days_remaining
    remaining_cost / current_pace
  end
end

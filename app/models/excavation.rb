class Excavation
  attr_accessor :activities, :ideal_finish_date

  def initialize
    @activities = []
  end

  def self.work_interval_in_days
    14
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
    completed_pace * 1.0 / Excavation.work_interval_in_days
  end

  def projected_days_remaining
    remaining_cost / current_pace
  end

  def projected_end_date
    Time.zone.today + projected_days_remaining
  end

  def on_time?
    return false if projected_days_remaining.nan?
    projected_end_date <= ideal_finish_date
  end
end

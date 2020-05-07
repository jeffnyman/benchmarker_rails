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

    activities.all?(&:complete?)
  end
end

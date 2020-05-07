class Excavation
  def initialize
    @activities = []
  end

  def activities
    @activities
  end

  def finished?
    activities.length == 0
  end
end

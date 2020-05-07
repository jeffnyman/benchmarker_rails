class Excavation
  attr_accessor :activities

  def initialize
    @activities = []
  end

  def finished?
    activities.empty?
  end
end

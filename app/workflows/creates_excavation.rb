class CreatesExcavation
  attr_accessor :name, :excavation, :activity_string

  def initialize(name: "", activity_string: "")
    @name = name
    @activity_string = activity_string
    @success = false
  end

  def success?
    @success
  end

  def build
    self.excavation = Excavation.new(name: name)
    excavation.activities = convert_string_to_activities
    excavation
  end

  def create
    build
    result = excavation.save
    @success = result
  end

  def convert_string_to_activities
    activity_string.split("\n").map do |one_activity|
      name, cost_string = one_activity.split(":")
      Activity.new(name: name, cost: cost_as_integer(cost_string))
    end
  end

  def cost_as_integer(cost_string)
    return 1 if cost_string.blank?
    [cost_string.to_i, 1].max
  end
end

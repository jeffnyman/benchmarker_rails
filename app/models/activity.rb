class Activity < ApplicationRecord
  belongs_to :excavation

  def mark_as_completed(date = Time.current)
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

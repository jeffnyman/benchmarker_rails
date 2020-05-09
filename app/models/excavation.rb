class Excavation < ApplicationRecord
  validates :name, presence: true
  has_many :activities, dependent: :destroy

  def self.work_interval_in_days
    14
  end

  def finished?
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

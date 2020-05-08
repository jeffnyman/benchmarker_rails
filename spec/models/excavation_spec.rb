require 'rails_helper'

RSpec.describe Excavation, type: :model do
  describe "state" do
    let(:dig) { Excavation.new }
    let(:activity) { Activity.new }

    it "an excavation with no activities is finished" do
      expect(dig).to be_finished
    end

    it "an excavation with an incomplete activity is unfinished" do
      dig.activities << activity

      expect(dig).not_to be_finished
    end

    it "an excavation is finished if all activities are marked as completed" do
      dig.activities << activity
      activity.mark_as_completed

      expect(dig).to be_finished
    end

    it "an excavation that has no completed tasks is represented correctly" do
      expect(dig.completed_pace).to eq(0)
      expect(dig.current_pace).to eq(0)
      expect(dig.projected_days_remaining).to be_nan
      expect(dig).not_to be_on_time
    end
  end

  describe "costs" do
    let(:dig) { Excavation.new }
    let(:complete) { Activity.new(cost: 10, completed: 2.days.ago) }
    let(:small_incomplete) { Activity.new(cost: 2) }
    let(:large_incomplete) { Activity.new(cost: 25) }

    before(:example) do
      dig.activities = [complete, small_incomplete, large_incomplete]
    end

    it "an excavation will have a total cost" do
      expect(dig.total_cost).to eq(37)
    end

    it "an excavation will have a remaining cost" do
      expect(dig.remaining_cost).to eq(27)
    end

    it "excavation pace is calculated from completed activities" do
      expect(dig.completed_pace).to eq(10)
    end

    it "projected days remaining is calculated from pace and cost" do
      expect(dig.projected_days_remaining).to eq(37.8)
    end
  end

  describe "pace" do
    let(:dig) { Excavation.new }
    let(:completed_recently) { Activity.new(cost: 5, completed: 1.day.ago) }
    let(:completed_awhile_ago) { Activity.new(cost: 10, completed: 1.month.ago) }
    let(:small_incomplete) { Activity.new(cost: 2) }
    let(:large_incomplete) { Activity.new(cost: 25) }

    # This calculation still feels like it's not being incorporated well.
    # The idea is you take the work interval divided by the total cost of
    # all completed activities. That is how the current pace is derived.
    let(:pace_derivation) {
      1.0 / (Excavation.work_interval_in_days * 1.0 / dig.completed_pace)
    }

    before(:example) do
      dig.activities = [
        completed_recently, completed_awhile_ago,
        small_incomplete, large_incomplete
      ]
    end

    it "excavation pace is calculated from completed activities" do
      expect(dig.completed_pace).to eq(5)
    end

    it "excavation pace is derived from rate of completed activities" do
      expect(dig.current_pace).to eq(pace_derivation)
    end

    it "projected days remaining is calculated from pace and cost" do
      expect(dig.projected_days_remaining).to eq(75.6)
    end

    it "excavations can determine if they are not on schedule" do
      dig.ideal_finish_date = 2.weeks.from_now
      expect(dig).not_to be_on_time
    end

    it "excavations can determine if they are on schedule" do
      dig.ideal_finish_date = 3.months.from_now
      expect(dig).to be_on_time
    end
  end
end

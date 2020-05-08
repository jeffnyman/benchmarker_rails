require "rails_helper"

RSpec.describe Excavation do
  describe "state" do
    let(:dig) { Excavation.new }
    let(:activity) { Activity.new }

    it "an excavation with no activities is finished" do
      expect(dig).to be_finished
    end

    # I could write a test for "an excavation wiht a complete activity is
    # finished" but while that would have me add code, it would actually
    # not provide a test that fails *given the current code*. So instead
    # I do the following one. Notice that even here nothing actually says
    # that the activity is complete or incomplete. Yet that is my intent.
    # So the assumption being made here is that a new activity is one that
    # is incomplete.

    it "an excavation with an incomplete activity is unfinished" do
      dig.activities << activity

      expect(dig).not_to be_finished
    end

    # Because of the tests that were added to the activity_spec, now the
    # distinction between complete/incomplete can be applied in the context
    # of the excavation as a whole.

    it "an excavation is finished if all activities are marked as completed" do
      dig.activities << activity
      activity.mark_as_completed

      expect(dig).to be_finished
    end

    # This was added late to make sure that all of the material that was
    # added, in terms of the calculations, are appropriately handled.

    it "an excavation that has no completed tasks is represented correctly" do
      expect(dig.completed_pace).to eq(0)
      expect(dig.current_pace).to eq(0)
      expect(dig.projected_days_remaining).to be_nan
      expect(dig).not_to be_on_time
    end
  end

  # At this point, we have to calculate how much of a project is remaining.
  # This will be via a count of the activities in the project that have yet
  # to marked as completed. It will also be necessary to figure out the rate
  # that activities are being completed. Those two values can then be used
  # to determine a possible end date.

  describe "costs" do
    let(:dig) { Excavation.new }
    let(:complete) { Activity.new(cost: 10, completed: true) }
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
  end

  # At this point, the excavation has to be given activities that are in and
  # out of the work interval window.

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

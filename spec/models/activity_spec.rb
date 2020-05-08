require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe "state" do
    let(:activity) { Activity.new }

    it "a new activity is incomplete by default" do
      expect(activity).not_to be_complete
    end

    it "an activity can be completed" do
      activity.mark_as_completed

      expect(activity).to be_complete
    end
  end

  describe "pace" do
    let(:work_interval) { Excavation.work_interval_in_days }
    let(:activity) { Activity.new(cost: 5) }

    it "incomplete activities do not count toward the pace" do
      expect(activity).not_to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(0)
    end

    it "activities completed within the work interval count toward the pace" do
      activity.mark_as_completed(3.days.ago)
      expect(activity).to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(5)
    end

    it "activities completed outside the work interval do not count toward the pace" do
      activity.mark_as_completed(1.month.ago)
      expect(activity).not_to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(0)
    end

    it "activities completed just below the boundary of the work interval count toward the pace" do
      activity.mark_as_completed((work_interval - 1).days.ago)
      expect(activity).to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(5)
    end

    it "activities completed at the boundary of the work interval do not count toward the pace" do
      activity.mark_as_completed(work_interval.days.ago)
      expect(activity).not_to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(0)
    end
  end
end

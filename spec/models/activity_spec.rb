require "rails_helper"

RSpec.describe Activity do
  describe "state" do
    let(:activity) { Activity.new }

    # These tests start to set up a major distinction that I brought up in
    # the excavation spec, which is that activities can be complete or
    # incomplete. Now the context of an activity being incomplete by default
    # is part of the design rather than something that simply happened to be
    # the case prior ot this.

    it "a new activity is incomplete by default" do
      expect(activity).not_to be_complete
    end

    it "an activity can be completed" do
      activity.mark_as_completed

      expect(activity).to be_complete
    end
  end

  describe "pace" do
    let(:activity) { Activity.new(cost: 5) }

    # These tests focus on the rate of activity completition within the
    # context of an excavation. The barometer for completion will be a time
    # duration of two weeks. This means activities can be distinguished in
    # terms of those that did complete in the last two weeks and those that
    # did not. The idea being that an activity completed within the last two
    # weeks counts toward the pace of the excavation.

    it "incomplete activities do not count toward the pace" do
      expect(activity).not_to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(0)
    end

    it "activities completed within the work interval count toward the pace" do
      activity.mark_as_completed(1.day.ago)
      expect(activity).to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(5)
    end

    it "activities completed outside the work interval do not count toward the pace" do
      activity.mark_as_completed(1.month.ago)
      expect(activity).not_to be_part_of_pace
      expect(activity.counts_towards_pace).to eq(0)
    end
  end
end

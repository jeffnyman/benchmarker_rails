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
end

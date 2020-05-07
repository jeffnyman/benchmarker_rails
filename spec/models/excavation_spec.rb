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
  end
end

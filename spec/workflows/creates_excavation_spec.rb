require "rails_helper"

RSpec.describe CreatesExcavation do
  let(:creator) {
    CreatesExcavation.new(name: "Talpiot Tomb", activity_string: activity_string)
  }

  describe "initial state" do
    let(:activity_string) { "" }

    it "an excavation will be created with a name" do
      creator.build
      expect(creator.excavation.name).to eq("Talpiot Tomb")
    end
  end

  describe "activity string parsing" do
    let(:activities) { creator.convert_string_to_activities }

    context "handles creating an excavation with no activities" do
      let(:activity_string) { "" }

      specify { expect(activities).to be_empty }
    end

    context "handles creating an excavation with a single activity, no specified cost" do
      let(:activity_string) { "Clear out antechamber" }

      specify { expect(activities[0].cost).to eq(1) }
      specify {
        expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
      }
    end

    context "handles creating an excavation with a single activity, specified cost" do
      let(:activity_string) { "Clear out antechamber:3" }

      specify { expect(activities[0].cost).to eq(3) }
      specify {
        expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 3)
      }
    end

    context "handles creating an excavation with a single activity, specified cost of 0" do
      let(:activity_string) { "Clear out antechamber:0" }

      specify { expect(activities[0].cost).to eq(1) }
      specify {
        expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
      }
    end

    context "handles creating an excavation with a single activity, malformed cost" do
      let(:activity_string) { "Clear out antechamber:" }

      specify { expect(activities[0].cost).to eq(1) }
      specify {
        expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
      }
    end

    context "handles creating an excavation with a single activity, negative cost" do
      let(:activity_string) { "Clear out antechamber:-1" }

      specify { expect(activities[0].cost).to eq(1) }
      specify {
        expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
      }
    end

    context "handles creating an excavation with multiple activities, costs specified" do
      let(:activity_string) { "Clear out antechamber:3\nRemove terra rossa soil:5" }

      specify {
        expect(activities).to match(
          [
            an_object_having_attributes(name: "Clear out antechamber", cost: 3),
            an_object_having_attributes(name: "Remove terra rossa soil", cost: 5)
          ]
        )
      }
    end

    context "handles attaching activities to the excavation" do
      let(:activity_string) { "Clear out antechamber:3\nRemove terra rossa soil:5" }

      before(:example) { creator.create }
      specify { expect(creator.excavation.activities.last.cost).to eq(5) }
      specify { expect(creator.excavation).not_to be_a_new_record }
    end
  end
end

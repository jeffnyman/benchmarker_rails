require "rails_helper"

RSpec.describe CreatesExcavation do
  describe "initial state" do
    it "an excavation will be created with a name" do
      creator = CreatesExcavation.new(name: "Talpiot Tomb")
      creator.build
      expect(creator.excavation.name).to eq("Talpiot Tomb")
    end
  end

  describe "activity string parsing" do
    it "handles creating an excavation with no activities" do
      creator = CreatesExcavation.new(name: "Talpiot Tomb", activity_string: "")
      activities = creator.convert_string_to_activities
      expect(activities).to be_empty
    end

    it "handles creating an excavation with a single activity, no specified cost" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber"
      )
      activities = creator.convert_string_to_activities
      expect(activities[0].cost).to eq(1)
      expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
    end

    it "handles creating an excavation with a single activity, specified cost" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:3"
      )
      activities = creator.convert_string_to_activities
      expect(activities[0].cost).to eq(3)
      expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 3)
    end

    it "handles creating an excavation with a single activity, specified cost of 0" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:0"
      )
      activities = creator.convert_string_to_activities
      expect(activities[0].cost).to eq(1)
      expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
    end

    it "handles creating an excavation with a single activity, malformed cost" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:"
      )
      activities = creator.convert_string_to_activities
      expect(activities[0].cost).to eq(1)
      expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
    end

    it "handles creating an excavation with a single activity, negative cost" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:-1"
      )
      activities = creator.convert_string_to_activities
      expect(activities[0].cost).to eq(1)
      expect(activities.first).to have_attributes(name: "Clear out antechamber", cost: 1)
    end

    it "handles creating an excavation with multiple activities, costs specified" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:3\nRemove terra rossa soil:5"
      )
      activities = creator.convert_string_to_activities
      expect(activities).to match(
        [
          an_object_having_attributes(name: "Clear out antechamber", cost: 3),
          an_object_having_attributes(name: "Remove terra rossa soil", cost: 5)
        ]
      )
    end

    it "handles attaching activities to the excavation" do
      creator = CreatesExcavation.new(
        name: "Talpiot Tomb", activity_string: "Clear out antechamber:3\nRemove terra rossa soil:5"
      )
      creator.create
      # expect(creator.excavation.activities.cost).to eq(8)
      expect(creator.excavation).not_to be_a_new_record
    end
  end
end

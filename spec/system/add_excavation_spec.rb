require "rails_helper"

RSpec.describe "Excavations", type: :system do
  it "users can create an excavation with activities" do
    visit new_excavation_path

    fill_in "Name", with: "Talpiot Tomb"
    fill_in "Activities", with: "Expose antechamber:3\nRemove terra rossa soil:5"
    click_on("Create Excavation")

    visit excavations_path

    @excavation = Excavation.find_by(name: "Talpiot Tomb")

    expect(page).to have_selector(
      "#excavation_#{@excavation.id} .name", text: "Talpiot Tomb"
    )

    expect(page).to have_selector(
      "#excavation_#{@excavation.id} .total-cost", text: "8"
    )
  end
end

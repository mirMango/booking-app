require "rails_helper"

RSpec.describe "Sanity check" do
  it "boots the Rails application" do
    expect(Rails.application).to be_present
  end

  it "verifies FactoryBot is configured" do
    expect(FactoryBot.definition_file_paths).to be_an(Array)
  end
end

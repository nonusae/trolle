require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  scenario "user creates a new project" do
    user = FactoryGirl.create(:user)
    # using our customer login helper:
    # sign_in_as user
    # or the one provided by Devise:
    login_as user, scope: :user
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      aggregate_failures do
        expect(page).to have_content "Project was successfully created"
        expect(page).to have_content "Test Project"
        expect(page).to have_content "Owner: #{user.name}"
      end
    }.to change(user.projects, :count).by(1)
  end

  scenario "user completes a project" do
    # given a user with a project
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project, owner: user)
    # and that the user in logged in
    login_as user , scope: :user

    # when the user visites the project page
    visit project_path(project)

    ## Complete label not appear yet
    expect(page).to_not have_content "Completed"

    # and the user clicks the "complete" button
    click_button "Complete"

    # then the project is marked as completed
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"

  end

end
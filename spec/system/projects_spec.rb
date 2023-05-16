require "rails_helper"

# - Create A New Project

RSpec.feature "Project Testing", type: :system do
  let(:user){ create(:user) }
  let(:project_1){ create(:project) }
  let(:project_2){ create(:project) }

  scenario "Successfully Create An unconfigured Project" do
    login(user)
    visit new_project_path

    expect(page).to have_css('#project_name')
    expect(page).to have_css('#project_description')
  end

  scenario "User shall not be able to create project with empty fields" do
    login(user)
    visit new_project_path

    click_on 'Proceed to Next Step'
    expect(page).to have_css('#project_name')
    expect(page).to have_css('#project_description')
  end

  scenario "User shall be able to create project with filled fields" do
    login(user)
    visit new_project_path

    fill_in 'project[name]', with: 'Test Project'
    fill_in 'project[description]', with: 'Test Description'
    fill_in 'project[k_value]', with: 8
    find(:css, "#project_model").find(:option, 'lenet5').select_option
    find(:css, "#project_operator_type").find(:option, 'neuron_level').select_option
    click_on 'Proceed to Next Step'
    expect(Project.count).to eq 1
    expect(Project.last.status).to eq "unconfigured"
  end

  scenario "User shall not be able to create project with empty name" do
    login(user)
    visit new_project_path

    fill_in 'project[description]', with: 'Test Description'
    fill_in 'project[k_value]', with: 8
    find(:css, "#project_model").find(:option, 'lenet5').select_option
    find(:css, "#project_operator_type").find(:option, 'neuron_level').select_option
    click_on 'Proceed to Next Step'
    expect(Project.count).to eq 0
  end

  scenario "User shall not be able to create project with empty k value" do
    login(user)
    visit new_project_path

    fill_in 'project[name]', with: 'Test Project'
    fill_in 'project[description]', with: 'Test Description'
    find(:css, "#project_model").find(:option, 'lenet5').select_option
    find(:css, "#project_operator_type").find(:option, 'neuron_level').select_option
    click_on 'Proceed to Next Step'
    expect(Project.count).to eq 0
  end

  scenario "User shall not be able to create project with empty model & operator" do
    login(user)
    visit new_project_path

    fill_in 'project[name]', with: 'Test Project'
    fill_in 'project[description]', with: 'Test Description'
    fill_in 'project[k_value]', with: 8
    click_on 'Proceed to Next Step'
    expect(Project.count).to eq 0
  end

  scenario "User shall be able to access mutation score page" do
    login(user)
    visit apply_mutation_score_path(model_name: "lenet5")

    expect(page).to have_text "No Projects Found, Please Create a One."
  end

  scenario "User shall be able to access mutation analysis page" do
    login(user)
    visit mutation_analysis_path

    expect(page).to have_text "No Projects Found, Please Create a One."
  end
end

require "rails_helper"

feature 'Admin creates a tool' do
  NEW_ADMIN_SUBMIT_BTN = "Créer et continuer l'édition"
  STEP_1_ADMIN_SUBMIT_BTN = "Enregistrer et continuer l'édition"
  STEP_2_ADMIN_SUBMIT_BTN = "Enregistrer et retourner à la liste"

    
  before(:each) do
    admin = Admin.first
    login_as admin, scope: :admin
  end

  scenario 'happy path' do
    # New ----------------------------------------------------------------------------------
    visit new_admin_tool_path
    fill_part_one_mandatory_fields
    click_button NEW_ADMIN_SUBMIT_BTN
    # TODO : improve (Pas trouvé mieux pour le moment)
    new_tool = Tool.last
    expect(page).to have_current_path(edit_part_2_admin_tool_path(new_tool))

    # Part 2 ----------------------------------------------------------------------------------
    fill_in 'tool_goal', with: 'objectifs'
    fill_in 'tool_teaser', with: 'resume'
    fill_in 'tool_description', with: 'description'
    fill_in 'tool_submitter_email', with: 'truc@stuce.com'
    click_button STEP_2_ADMIN_SUBMIT_BTN
    # save_and_open_page
    expect(page).to have_current_path(admin_tools_path)
  end

  scenario 'with wrong fields' do
    # Blank new ----------------------------------------------------------------------------------
    visit new_admin_tool_path
    click_button NEW_ADMIN_SUBMIT_BTN
    expect(page).to have_content("erreurs")

    # Part 2 ----------------------------------------------------------------------------------
    fill_part_one_mandatory_fields
    click_button NEW_ADMIN_SUBMIT_BTN
    # ici, on est dans part 2
    click_button STEP_2_ADMIN_SUBMIT_BTN
    expect(page).to have_content("erreurs")

    # Back to part 1 ------------------------------------------------------------------
    # pas d'erreur de part 2 ne doivent apparaitre sur part 1
    click_link "Etape 1"
    click_button STEP_1_ADMIN_SUBMIT_BTN
    expect(page).not_to have_content("erreurs")
  end

  # ====================================================

  def fill_part_one_mandatory_fields
    fill_in 'tool_title', with: 'Abigaël'
    # choose('tool_axis_id_1', visible: false)
    select Axis.first.title, from: 'tool_axis_id'
    select ToolCategory.first.title, from: 'tool_tool_category_id'
  end

end
require "rails_helper"

feature 'User creates a tool' do

  STEP_1_SUBMIT_BTN = "Etape suivante"
  STEP_2_SUBMIT_BTN = "Envoyer"

  scenario 'happy path' do
    # New ----------------------------------------------------------------------------------
    visit new_tool_path
    fill_part_one_mandatory_fields
    # TODO : improve (Pas trouvé mieux pour le moment)
    new_tool = Tool.last
    expect(page).to have_current_path(edit_part_2_tool_path(new_tool))

    # Part 2 ----------------------------------------------------------------------------------
    fill_in 'tool_goal', with: 'objectifs'
    fill_in 'tool_teaser', with: 'resume'
    fill_in 'tool_description', with: 'description'
    click_button STEP_2_SUBMIT_BTN
    # save_and_open_page
    expect(page).to have_current_path(submission_success_tool_path(new_tool))
  end

  scenario 'with wrong fields' do
    # Blank new ----------------------------------------------------------------------------------
    visit new_tool_path
    click_button STEP_1_SUBMIT_BTN
    expect(page).to have_content("erreurs")

    # Part 2 ----------------------------------------------------------------------------------
    fill_part_one_mandatory_fields
    # ici, on est dans part 2
    click_button STEP_2_SUBMIT_BTN
    expect(page).to have_content("erreurs")

    # Back to part 1 ------------------------------------------------------------------
    # pas d'erreur de part 2 ne doivent apparaitre sur part 1
    click_link "Etape 1"
    click_button STEP_1_SUBMIT_BTN
    expect(page).not_to have_content("erreurs")
  end

  # ====================================================

  def fill_part_one_mandatory_fields
    fill_in 'tool_title', with: 'Abigaël'
    choose('tool_axis_id_1', visible: false)
    select 'Energizers', from: 'tool_tool_category_id', visible: false
    click_button STEP_1_SUBMIT_BTN
  end

end
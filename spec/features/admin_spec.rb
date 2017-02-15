require "rails_helper"

feature "Connexion/Déconnexion Admin" do
  scenario "Admin se connecte avec de bons identifiants" do
    visit admin_root_path

    expect(current_path).to eq(new_admin_session_path)

    fill_in "admin_email", with: "technique@studio-hb.com"
    fill_in "admin_password", with: "password"
    click_button "Connexion"

    expect(current_path).to eq(admin_root_path)
  end

  scenario "J'essaie de me connecter avec de mauvais identifiants" do
    visit admin_root_path

    expect(current_path).to eq(new_admin_session_path)
    fill_in "admin_email", with: "technique@studio-hb.com"
    fill_in "admin_password", with: "wrong_password"
    click_button "Connexion"

    expect(current_path).to eq(new_admin_session_path) 
  end

  scenario "Je suis connecté en tant qu'admin, je retourne sur le site et je reviens en admin sans me connecter" do
    admin = Admin.first
    login_as admin, scope: :admin

    visit admin_root_path
    expect(current_path).to eq(admin_root_path)

    click_link "Retour au site"
    expect(current_path).to eq(root_path)

    visit admin_root_path
    expect(current_path).to eq(admin_root_path)
  end

  scenario "Je suis connecté en tant qu'admin, je me déconnecte" do
    admin = Admin.first
    login_as admin, scope: :admin

    visit admin_root_path
    expect(current_path).to eq(admin_root_path)

    click_link "Se déconnecter"
    expect(current_path).to eq(root_path)

    visit admin_root_path
    expect(current_path).to eq(new_admin_session_path)
  end
end
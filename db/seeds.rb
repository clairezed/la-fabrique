# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
a1 = Admin.where(email: "clairezuliani+admin@gmail.com").first_or_initialize

if ["production","staging"].include?(Rails.env)
  a1.update_attributes(:password => "aqwxsz21")
else
  a1.update_attributes(:password => "password")
end

seo1 = Seo.where(param: "home").first_or_create


# Thèmes ======================================================

[
  {
    title: "Mobilité",
    id_key: "mobility",
    enabled: true
  }
].each do |option|
  Theme.where(title: option[:title]).first_or_create(id_key: option[:id_key], enabled: option[:enabled])
end

# Axes ========================================================

mobility_theme = Theme.where(id_key: "mobility").first

[
  {
    title: "Interculturalité", 
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au départ",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au retour",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Dispositifs de la mobilité",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Valorisation des compétences",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Gestion des conflits",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Animation de groupe",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Méthodologie de projets",
    description: "",
    theme_id: mobility_theme.id,
    enabled: true
  }

].each do |option|
  Axis.where(title: option[:title]).first_or_create(
    theme_id: option[:theme_id], 
    description: option[:description], 
    enabled: option[:enabled]
  )
end


# Catégories d'outil ========================================================

[
  {
    title: "Présentation", enabled: true,
    description: "name game…"
  },
  {
    title: "Energizers", enabled: true,
    description: ""
  },
  {
    title: "Ice-breakers", enabled: true,
    description: ""
  },
  {
    title: "Team building", enabled: true,
    description: ""
  },
  {
    title: "Jeux de rôle / Simulation", enabled: true,
    description: ""
  },
  {
    title: "Création", enabled: true,
    description: ""
  },
  {
    title: "Débriefing", enabled: true,
    description: ""
  },
  {
    title: "Retour d’expérience", enabled: true,
    description: ""
  },
  {
    title: "Communication / Débat / Discussion", enabled: true,
    description: "bâton de parole…"
  },
  {
    title: "Evaluation", enabled: true,
    description: ""
  },
  {
    title: "Pour soi", enabled: true,
    description: "pour se préparer / ex: respiration…"
  },
  {
    title: "Gestion de groupe", enabled: true,
    description: ""
  },
  {
    title: "Témoignage", enabled: true,
    description: ""
  },
  {
    title: "Brainstorming", enabled: true,
    description: ""
  },
].each do |option|
  ToolCategory.where(title: option[:title]).first_or_create(
    description: option[:description], 
    enabled: option[:enabled]
  )
end

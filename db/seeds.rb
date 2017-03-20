# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
a1 = Admin.where(email: "clairezuliani+admin@gmail.com").first_or_initialize

if ["production","staging"].include?(Rails.env)
  a1.update_attributes(:password => "password")
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
    id_key: :interculturality,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au départ",
    description: "",
    id_key: :departure_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au retour",
    description: "",
    id_key: :return_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Dispositifs de la mobilité",
    description: "",
    id_key: :mobility_system,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Valorisation des compétences",
    description: "",
    id_key: :skill_promotion,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Gestion des conflits",
    description: "",
    id_key: :conflict_management,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Animation de groupe",
    description: "",
    id_key: :group_facilitation,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Méthodologie de projets",
    description: "",
    id_key: :project_methodology,
    theme_id: mobility_theme.id,
    enabled: true
  }

].each do |option|
  Axis.where(title: option[:title]).first_or_create(
    id_key: option[:id_key],
    theme_id: option[:theme_id], 
    description: option[:description], 
    enabled: option[:enabled]
  )
end


# Catégories d'outil ========================================================

[
  {
    title: "Méthode de présentation", enabled: true,
    description: "name game…"
  },
  {
    title: "Energizers", enabled: true,
    description: ""
  },
 {
    title: "Exercice", enabled: true,
    description: ""
  },
 {
    title: "Base de données", enabled: true,
    description: ""
  },
  {
    title: "Brise glace", enabled: true,
    description: ""
  },
  {
    title: "Jeux de rôle", enabled: true,
    description: ""
  },
  {
    title: "Technique de créativité", enabled: true,
    description: ""
  },
  {
    title: "Débriefing", enabled: true,
    description: ""
  },
  {
    title: "Analyse", enabled: true,
    description: ""
  },
  {
    title: "Retour d’expérience", enabled: true,
    description: ""
  },
  {
    title: "Echange", enabled: true,
    description: ""
  },
  {
    title: "Evaluation", enabled: true,
    description: ""
  },
  {
    title: "Cas pratique", enabled: true,
    description: "bâton de parole…"
  },
  {
    title: "Mise en situation", enabled: true,
    description: "pour se préparer / ex: respiration…"
  },
  {
    title: "Témoignage", enabled: true,
    description: ""
  },
  {
    title: "Carte", enabled: true,
    description: ""
  },
  {
    title: "Brainstorming", enabled: true,
    description: ""
  },
    {
    title: "Documentation pédagogique", enabled: true,
    description: ""
  },
    {
    title: "Document de fond", enabled: true,
    description: ""
  }
].each do |option|
  ToolCategory.where(title: option[:title]).first_or_create(
    description: option[:description], 
    enabled: option[:enabled]
  )
end

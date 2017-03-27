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
    description: "Description de l'axe",
    id_key: :interculturality,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au départ",
    description: "Description de l'axe",
    id_key: :departure_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au retour",
    description: "Description de l'axe",
    id_key: :return_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Dispositifs de la mobilité",
    description: "Description de l'axe",
    id_key: :mobility_system,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Valorisation des compétences",
    description: "Description de l'axe",
    id_key: :skill_promotion,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Gestion des conflits",
    description: "Description de l'axe",
    id_key: :conflict_management,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Animation de groupe",
    description: "Description de l'axe",
    id_key: :group_facilitation,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Méthodologie de projets",
    description: "Description de l'axe",
    id_key: :project_methodology,
    theme_id: mobility_theme.id,
    enabled: true
  }

].each do |option|
  Axis.where(title: option[:title]).first_or_create(
    id_key: option[:id_key],
    theme_id: option[:theme_id], 
    description: [ option[:description], option[:title]].join(" "), 
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


# Tool Helps  ========================================================

[
  {
    field: "title",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "axis_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "duration",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "group_size",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "level",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "tool_category_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "public",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "tag_ids",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "goal",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "teaser",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "axis_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "description",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "advice",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "material",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "source",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "licence",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "tool_attachment",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "link",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  },
  {
    field: "submitter_email",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champs"
  }
].each do |option|
  ToolHelp.where(field: option[:field]).first_or_create(
    content: option[:content], 
    title: option[:title]
  )
end
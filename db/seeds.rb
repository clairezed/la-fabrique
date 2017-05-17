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
    color: "#cc3333",
    enabled: true
  },
    {
    title: "Préparation au départ",
    description: "Description de l'axe",
    id_key: :departure_preparation,
    theme_id: mobility_theme.id,
    color: "#99cc66",
    enabled: true
  },
    {
    title: "Préparation au retour",
    description: "Description de l'axe",
    id_key: :return_preparation,
    theme_id: mobility_theme.id,
    color: "#c0a476",
    enabled: true
  },
    {
    title: "Dispositifs de la mobilité",
    description: "Description de l'axe",
    id_key: :mobility_system,
    theme_id: mobility_theme.id,
    color: "#663399",
    enabled: true
  }, 
  {
    title: "Valorisation des compétences",
    description: "Description de l'axe",
    id_key: :skill_promotion,
    theme_id: mobility_theme.id,
    color: "#ffd966",
    enabled: true
  }, 
  {
    title: "Gestion des conflits",
    description: "Description de l'axe",
    id_key: :conflict_management,
    theme_id: mobility_theme.id,
    color: "#996633",
    enabled: true
  }, 
  {
    title: "Animation de groupe",
    description: "Description de l'axe",
    id_key: :group_facilitation,
    theme_id: mobility_theme.id,
    color: "#f1875d",
    enabled: true
  }, 
  {
    title: "Méthodologie de projets",
    description: "Description de l'axe",
    id_key: :project_methodology,
    theme_id: mobility_theme.id,
    color: "#40aeb4",
    enabled: true
  }

].each do |option|
  axis = Axis.where(title: option[:title]).first_or_create(
    id_key: option[:id_key],
    description: [ option[:description], option[:title]].join(" "), 
    theme_id: option[:theme_id], 
    color: option[:color], 
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
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "axis_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "duration",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "group_size",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "level",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "tool_category_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "public",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "tag_ids",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "goal",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "teaser",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "axis_id",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "description",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "advice",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "material",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "source",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "licence",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "tool_attachment",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "link",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  },
  {
    field: "contact",
    title: "",
    content: "Ceci est un texte expliquant comment remplir le champ"
  }
].each do |option|
  ToolHelp.where(field: option[:field]).first_or_create(
    content: option[:content], 
    title: option[:title]
  )
end
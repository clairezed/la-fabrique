# frozen_string_literal: true

class SeedTools

CREDIBLE_DATA = [
  {
    tool:
    {
      title: 'Abigaël',
      axis_id: Axis.where(id_key: "interculturality").first.id,
      tool_category_id: ToolCategory.where(title: "Jeux de rôle").first.id,
      group_size: Tool.group_sizes['size_1'],
      duration: Tool.durations[:duration_2],
      level: Tool.levels[:medium],
      public: "adolescents (à partir de 15 ans) et adultes",
      material: "Un exemplaire du texte en pièce jointe par participant",
      goal: 'Prendre conscience des diéfférentes perceptions de valeurs et de représentations de chacun de nous',
      teaser: "Ce jeu va permettre aux participants de se confronter aux différences de valeurs et de représentations",
      description_type: :steps,
      advice: "Ce jeu n’est pas fait pour obtenir un consensus. L’animateur doit veiller à ce que \
        chacun puisse s’exprimer et être respecter dans les jugements qu’il émet.",
      source: "Conseil de l’Europe et Visa pour le voyage du CCFD-Terre solidaire",
      licence: "Texte extrait du « T-kit n°4 : l’apprentissage interculturel » Éditions du conseil de \
        l’Europe. © Tous droits réservés"
    },
    steps:
      [
        { 
          description: "Distribuer un exemplaire du texte est distribué à chaque participant. Ils sont invités à le lire individuellement et à se demander, parmi tous les personnages :\r\n\r\n- Qui s’est le plus mal comporté\r\n\r\n- Qui s’est le mieux comporté"
        },
        {
          description: "Former des groupes de 4 à 6 personnes. Ils sont invités à échanger à propos de leurs avis sur les comportements des personnages et à établir un classement en premier, le personnage qui s’est le mieux comporté, en dernier le personnage qui s’est le plus mal comporté. Le classement doit être effectué par rapport aux valeurs et aux comportements des personnages."
        },
        {
          description: "Faire un débriefing collectif. Les participants se réunissent. Chaque groupe donne son classement des personnages. Les participants sont invités à répondre aux questions suivantes en grand groupe :\r\n" +
           "o Quelles sont les différences dans les classements ?\r\n" +
           "o Est-ce que ça vous surprend ?\r\n" +
           "o Comment vous êtes-vous décidés ?\r\n" +
           "o Qu’est-ce qui a été le plus difficile lors de vos discussions ?"
        }
      ],
    tags: ["valeurs", "différences", "dialogue", "écoute"],
    links: [{url: "http://marges.clairezuliani.com/", format_type: Link.format_types.keys.sample}]
  }
]


  def self.call
    CREDIBLE_DATA.each do |attributes|
      ActiveRecord::Base.transaction do
        begin
          tool = Tool.new(attributes[:tool])
          tool.save!
          attributes[:steps].each do |step_attributes|
            tool.steps.create!(step_attributes)
          end
          attributes[:tags].each do |tag_title|
            tag = Tag.where(title: tag_title).first_or_create!
            tool.tags.push(tag)
          end
          attributes[:links].each do |link_attributes|
            tool.links.create!(link_attributes)
          end
          tool.accept!
        rescue
          p tool.errors 
        end
      end
    end
  end



end
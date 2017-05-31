# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Base admin. Don't forget to change password in staging and production
a1 = Admin.where(email: "clairezuliani+admin@gmail.com").first_or_initialize
a1.update_attributes(:password => "password")

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
    description: "Qu’est-ce que l’interculturalité ?
      Comment appréhender la différence ?
      Comment travailler sur les stéréotypes, les préjugés et les représentations ?",
    id_key: :interculturality,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au départ",
    description: "Comment identifier les éléments qui vont faciliter ou freiner la réalisation du projet de mobilité ?\r\n 
      Comment définir son projet professionnel et personnel afin de le rendre cohérent avec son projet de mobilité ?\r\n 
      Comment choisir sa structure d’accueil et d’envoi ?\r\n 
      Que mettre en place pour partir en toute sécurité ?",
    id_key: :departure_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Préparation au retour",
    description: "Comment réaliser un bilan du projet de mobilité avec les partenaires impliqués ?\r\n 
      Quels outils pour structurer et organiser l’expérience de mobilité ?\r\n 
      Quelle suite donner au projet de mobilité ?",
    id_key: :return_preparation,
    theme_id: mobility_theme.id,
    enabled: true
  },
    {
    title: "Dispositifs de la mobilité",
    description: "Quels sont les acteurs de la mobilité ?\r\n
      Qui peut m’informer et m’accompagner sur les projets de mobilité ? Qui les finance ?\r\n
      Quels dispositifs pour quels projets ?",
    id_key: :mobility_system,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Valorisation des compétences",
    description: "Qu’est-ce qu’une compétence ?\r\n
      Savoir-être ? Savoir-faire ? Savoir ?\r\n
      Comment identifier, analyser et évaluer les compétences ?\r\n 
      Comment les valoriser ?",
    id_key: :skill_promotion,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Gestion des conflits",
    description: "Pourquoi existe-t-il des conflits ?\r\n 
      Quels  sont  les  éléments apaisant  et  intensifiant  un  conflit ?\r\n 
      Quelles sont les attitudes possibles face à un confit ? Quelles réponses y apporter ?\r\n 
      Comment (r)établir une communication bienveillante ?",
    id_key: :conflict_management,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Animation de groupe",
    description: "Comment se préparer à animer ?\r\n 
      Comment instaurer un climat favorable et dynamique ?\r\n 
      Quelles techniques d’animation pour faciliter la communication ?\r\n 
      Quelles techniques d’animation pour faciliter l’apprentissage et sa mise en application ?\r\n 
      Quelles techniques d’animation pour faciliter la coopération ?\r\n 
      Quelles techniques d’animation pour créer ?\r\n 
      Quelles techniques d’animation pour évaluer l’impact d’une action ?",
    id_key: :group_facilitation,
    theme_id: mobility_theme.id,
    enabled: true
  }, 
  {
    title: "Méthodologie de projets",
    description: "Comment passer d’une idée à une action concrète ?\r\n 
      Quelles sont les grandes étapes pour monter un projet ?\r\n 
      Comment concevoir ses objectifs ?\r\n 
      Quelles méthodes pour trouver les partenaires du projet ?\r\n 
      Quel outil pour la réalisation du budget, du planning et de la communication ?",
    id_key: :project_methodology,
    theme_id: mobility_theme.id,
    enabled: true
  }

].each do |option|
  axis = Axis.where(title: option[:title]).first_or_create(
    id_key: option[:id_key],
    description: option[:description], 
    theme_id: option[:theme_id], 
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
    title: "Qu’est-ce que le champ « titre » ?",
    content: "Il correspond au nom de votre outil. Obligatoire, il permet aux utilisateurs de localiser rapidement ce dernier en utilisant le module de recherche « Nom de l'outil » disponible sur la page d'accueil."
  },
  {
    field: "axis_id",
    title: "Comment renseigner le champ « axe thématique » ?",
    content: "Utilisez les questions suivantes pour déterminer l'axe dans lequel répertorier votre outil. Certains outils sont transversaux et peuvent s'inscrire dans plusieurs axes. N'hésitez pas à l'indiquer dans la partie « conseils ».\r\n 
      Les questions ci-dessous ne sont pas limitatives : elles sont là pour vous aider à cerner la nature et le contenu de l'axe proposé."
  },
  {
    field: "duration",
    title: "Qu’est-ce que le champ « durée » ?",
    content: "Il permet aux utilisateurs d'estimer la durée nécessaire pour mettre en œuvre l'outil que vous proposez. Si cela ne vous paraît pas pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge.  Il n'est pas obligatoire."
  },
  {
    field: "group_size",
    title: "Qu’est-ce que le champ « Nombre de pers. » ?",
    content: "Il permet aux utilisateurs d’estimer le nombre de personnes souhaitées pour le bon fonctionnement de l’outil que vous proposez. Si cela ne vous paraît par pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge. Il n’est pas obligatoire."
  },
  {
    field: "level",
    title: "Qu’est-ce que le champ « Niveau de difficulté » ?",
    content: "Il permet aux utilisateurs d’estimer le niveau de difficulté pour mettre en œuvre l’outil que vous proposez. Si cela ne vous paraît par pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge. Il n’est pas obligatoire.\r\n
      Facile : La mise en œuvre de l’outil ne demande ni préparation spécifique, ni compétence d’animation particulière.\r\n
      Intermédiaire : La mise en œuvre de l’outil demande soit une préparation spécifique, soit des compétences d’animation particulières.\r\n 
      Difficile : La mise en œuvre de l’outil requiert une préparation spécifique et des compétences d’animation particulières."
  },
  {
    field: "tool_category_id",
    title: "Qu’est-ce que le champ « Type d’outil » ?",
    content: "Il correspond à ce qu’est votre outil (par exemple : technique de créativité, jeu de rôle, brise-glace). Obligatoire, il permet aux utilisateurs de localiser rapidement ce dernier en utilisant le module de recherche « Type d’outil » disponible sur la page d'accueil."
  },
  {
    field: "public",
    title: "Qu’est-ce que le champ « Public privilégié » ?",
    content: "Il permet aux utilisateurs de déterminer le public cible de votre outil (par exemple : professionnels, jeunes, tout public). Si cela ne vous paraît par pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge. Il n’est pas obligatoire."
  },
  {
    field: "tag_ids",
    title: "Qu’est-ce que le champ « Mots-clés » ? ",
    content: "Il indique aux utilisateurs les notions éventuellement liées à votre outil (par exemple : genre, handicap, discrimination). Il n’est pas obligatoire, mais permet aux utilisateurs de localiser rapidement votre outil en utilisant le module de recherche « Mots-clés » disponible sur la page d'accueil."
  },
  {
    field: "goal",
    title: "Qu’est-ce que le champ « Objectifs » ?",
    content: "Il indique aux utilisateurs les objectifs attendus suite à la mise en œuvre de votre outil. Il est obligatoire. Décrivez de préférence ces derniers en commençant par un verbe d’action indiquant des comportements précis et observables (par exemple : indiquer, démontrer, identifier)."
  },
  {
    field: "teaser",
    title: "Qu’est-ce que le champ « Résumé » ?",
    content: "Il donne aux utilisateurs une courte mise en bouche de ce qu’offre votre outil. Il est obligatoire."
  },
  {
    field: "description",
    title: "Qu’est-ce que le champ « Marche à suivre » ?",
    content: "Il concerne les modalités d’utilisation de votre outil. Il est obligatoire. Deux options s’offrent à vous : « Description simple » ou « Par étapes ».\r\n
      Si vous choisissez « Description simple », la marche à suivre pour la mise en œuvre de votre outil est composée d’un seul bloc de texte.\r\n
      Si vous choisissez « Par étapes », la marche à suivre pour la mise en œuvre de votre outil est composée de plusieurs blocs de texte numérotés de 1 à 100."
  },
  {
    field: "advice",
    title: "Qu’est-ce que le champ « Conseils » ?",
    content: "Il permet de suggérer aux utilisateurs « vos petits plus » pour mettre en œuvre votre outil. Si cela ne vous paraît par pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge. Il n’est pas obligatoire."
  },
  {
    field: "material",
    title: "Qu’est-ce que le champ « Matériel » ?",
    content: "Il indique aux utilisateurs le matériel requis pour mettre en œuvre votre outil. Si cela ne vous paraît par pertinent (par exemple, si vous voulez publier un livret pédagogique), vous pouvez le laisser vierge. Il n’est pas obligatoire."
  },
  {
    field: "source",
    title: "Qu’est-ce que le champ « Source » ?",
    content: "Il indique aux utilisateurs l’origine de votre outil. Si vous ne connaissez pas sa provenance, vous pouvez mentionner « inconnue ».  Il n’est pas obligatoire."
  },
  {
    field: "licence",
    title: "Qu’est-ce que le champ « Licence d’utilisation » ?",
    content: "Il indique aux utilisateurs la licence d’utilisation de l’outil. Il n’est pas obligatoire."
  },
  {
    field: "tool_attachment",
    title: "Qu’est-ce que le champ « Support » ?",
    content: "Il permet l’ajout de documents associés à votre outil. Les formats autorisés sont : .pdf, .jpeg, .gif, .png, .doc, .xls, .ppt, .mp3, .wav. La taille maximale du document est de 8 Mo. Lors de l’ajout du document, vous pourrez lui donner un titre et indiquer son format (image, document texte type word / pdf, présentation type powerpoint, son, vidéo, autre). Il n’est pas obligatoire." 
  },
  {
    field: "link",
    title: "Qu’est-ce que le champ « Liens » ?",
    content: "Il permet l’ajout de liens associés à votre outil. Lors de l’ajout du lien, vous pourrez lui donner un titre et indiquer son format (image, document texte type word / pdf, présentation type powerpoint, son, vidéo, autre). Il n’est pas obligatoire."
  },
  {
    field: "contact",
    title: "Qu’est-ce que le champ « Contact » ?",
    content: "Il permet d’indiquer aux utilisateurs vos coordonnées sur la fiche outil."
  }
].each do |option|
  ToolHelp.where(field: option[:field]).first_or_create(
    content: option[:content], 
    title: option[:title]
  )
end


# Basïc Pages ==================================================
[
  { id_key: 'data_policy', title: "Charte des données personnelles", enabled: true },
  { id_key: 'legal_mentions', title: "Mentions légales", enabled: true },
  { id_key: 'cookies', title: "Cookies", enabled: true }
].each do |option|
  BasicPage.where(id_key: option[:id_key]).first_or_create(
    enabled: option[:enabled], 
    title: option[:title]
  )
end
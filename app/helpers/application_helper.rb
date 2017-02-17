module ApplicationHelper

  # LAYOUT #######################################################################

  # permet d'eviter l'indexation de la page par les
  # moteurs de recherche pour la page courante
  #
  def prevent_robots_indexation
    content_for[:prevent_robots_indexation ] = true
  end

  # insere un meta tag dans le layout pour empecher
  # les moteurs de recherche d'indexer la page
  #
  # usage : appeler #prevent_robots_indexation
  #         dans la page pour activer la protection
  #
  def robots_indexation_prevention
    return nil unless content_for? :prevent_robots_indexation
    '<meta name="robots" content="index, follow" />'.html_safe
  end

  # permet de reporter le rendu d'un script pour qu'il soit
  # rendu lors de l'appel a #render_document_ready_script
  # dans le layout
  #
  def document_ready_script( script )
    script = capture &block if block_given?
    content_for[ :document_ready_scripts ] = script
  end

  # insere des scripts en bas de page dans un $(document).ready
  #
  # usage : appeler #document_ready_script dans une page
  #
  # params : lib - permet de choisir quelle lib correspond a '$'
  #                pour le contexte d'execution, defaut: jQuery
  #
  def render_document_ready_scripts( lib = 'jQuery')
    return nil unless content_for? :document_ready_scripts
    javascript_tag <<-SCRIPTS
      (function($){ $(document).ready( function(){
        #{ content_for :document_ready_scripts }
      });})(#{lib});
    SCRIPTS
  end


  # NAVIGATION ####################################################################

  # permet d'indiquer dans quelle section de la navigation
  # se trouve la page actuelle
  #
  def set_navigation_section( section )
    content_for :current_navigation_section, section
  end

  # permet d'indiquer dans quelle sous-section de la navigation
  # se trouve la page actuelle
  #
  def set_navigation_sub_section( sub_section )
    content_for :current_navigation_sub_section, sub_section
  end

  # permet de déterminer si la page actuelle fait partie
  # d'une section de navigation passée en paramètre
  #
  def currently_in_section?( section )
    content_for( :current_navigation_section ) == section.to_s
  end

  # permet de déterminer si la page actuelle fait partie
  # d'une sous-section de navigation passée en paramètre
  #
  def currently_in_sub_section?( sub_section )
    content_for( :current_navigation_sub_section ) == sub_section.to_s
  end

  # crée un lien enveloppé dans un li
  # dont la class est 'active' si la section ou la sous-section
  # de navigation courante est celle donnee en argument
  #
  # usage : menu_link "home", root_path, section: :home
  # ou : menu_link "home", root_path, sub_section: :contact
  # paramêtre du <li>: li_class pour donner une classe au li: menu_link "home", root_path, section: home, li_class: "class_custom"
  #
  def menu_link(*args, &block)
    options = block_given? ? args[1] : args[2]
    section = options.delete(:section)
    sub_section = options.delete(:sub_section)
    
    li_class = options.delete(:li_class) || "nav-item"
    if section.present? && currently_in_section?(section) || sub_section.present? && currently_in_sub_section?(sub_section)
      li_class << " active"
    end
    tag_options = {class: li_class}
    content_tag :li, link_to(*args, &block), tag_options
  end

  # récupère le contenu texte sans les balises html ni sauts de ligne.
  #
  def html_to_text(html)
    require 'htmlentities'
    html = HTMLEntities.new.decode(html)
    html = ActionController::Base.helpers.strip_tags(html)
    html.gsub!(/\r\n?/, "\n")
    html.gsub("\n", " ")
  end

  # Gestionnaire du lien pour tri de colonne.
  #
  # Options :
  #   label: string
  #   icon_type: string: "numeric" ou "size" ("alphabet" par défaut)
  #   descend: boolean
  #   default: boolean
  #
  def hm_sort(field, options={})
    dir = 'asc'
    dir = 'desc' if options[:descend]
    fld = field.to_s

    cur = nil
    cur = "#{fld} #{dir}" if options[:default]
    cur = @sort || params[:sort] unless (@sort || params[:sort]).blank?

    if cur
      cur_fld, cur_dir = cur.split(/\s*,\s*/).first.split /\s+/
      dir = cur_dir == 'asc' ? 'desc' : 'asc' if cur_fld == fld
    end

    label = options[:label] || fld.titleize
  
    args = params.merge(sort: "#{fld} #{dir}").permit!
    args.delete_if {|k, v| %w(controller action).include?(k) }

    icon_type = case options[:icon_type]
    when "numeric"
      "order"
    when "size"
      "attributes"
    else
      "alphabet"
    end
    #byebug
    result = []
    result << link_to(label, args, class: dir)
    if cur_fld == fld
      result << content_tag(:span, "", class: "glyphicon glyphicon-sort-by-#{icon_type}#{'-alt' if dir == 'asc'}")
    end
    result.join(' ').html_safe
  end


  # NOTIFICATIONS FLASH ##########################################################

  FLASH_BS_TYPES = {
    error: "danger",
    alert: "warning",
    warning: "warning",
    notice: "success"
  }

  # Affichage des notifications flash s'il y en a.
  #
  def flash_messages
    result = content_tag :div, "", id: "flash", style: "display:none"

    FLASH_BS_TYPES.keys.each do |type|
      if flash[type].present?
        result << javascript_tag("flash('#{escape_javascript(flash[type])}', '#{FLASH_BS_TYPES[type]}')")
        break
      end
    end
    flash.discard

    result
  end

end
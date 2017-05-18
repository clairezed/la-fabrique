module Sitemap

  def self.get_all_pages(current_theme)

    hash = []

    # Page d'accueil
    h = {loc: Rails.application.routes.url_helpers.root_url, priority: 1, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Accueil", href: true, elements: []}
    hash << { home: h }

    # Proposer un outil
    h = {loc: Rails.application.routes.url_helpers.new_tool_url, priority: 0.6, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Proposer un outil", href: true, elements: []}
    hash << { home: h }



    # Fiches outil ===================================================

    # Axes

    axes = {loc: "#", priority: 1, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "Fiches outils", href: false, elements: []}
    hash << { axes: axes }

    current_theme.axes.includes(:seo).joins(:seo).each do |axis|
      axis_elt = {loc: Rails.application.routes.url_helpers.tools_url(by_axis: axis.id),
      priority: 0.9, lastmod: axis.updated_at.strftime("%Y-%m-%d"), title: axis.title, href: true, elements: []}

    # Fiches
      axis.tools.enabled.each do |tool|
        tool_elt = {loc: Rails.application.routes.url_helpers.tool_url(tool),
        priority: 0.7, lastmod: Time.now.strftime("%Y-%m-%d"), title: tool.title, href: true, elements: []}
        axis_elt[:elements] << { tool: tool_elt }
      end

      axes[:elements] << { axis: axis_elt }
    end

    # A propos -----------------------------------------------------
    about_page = BasicPage.enabled.where(id_key: 'about', theme: current_theme).first
    h = {loc: Rails.application.routes.url_helpers.basic_page_url(about_page), priority: 0.6, lastmod: Time.now.strftime("%Y-%m-%d"),
      title: "A propos", href: true, elements: []}
    hash << { home: h }

    hash

  end
end

class SitemapsController < ApplicationController

  respond_to :html, :xml

  def show
    get_seo_for_static_page("sitemap")
    @site_map = Sitemap.get_all_pages(current_theme)

    respond_with(@site_map) do |format|
      format.html {}
      format.xml { render layout: false }
    end
  end
end

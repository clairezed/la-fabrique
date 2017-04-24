# frozen_string_literal: true

#
# Gère la génération de PDF à partir d'une facture
#
class Pdf::ProjectBase < Pdf::Base
  include ApplicationHelper

  HEADER_HEIGHT = 60
  FOOTER_HEIGHT = 100

  protected #===================================================================

  # Structure -----------------------------------------------------
  def contents
    current_document = self
    within_document_boundaries do
      current_document.repeat :all do
        current_document.header
      end
      within_body(bounds.left , bounds.top - HEADER_HEIGHT, bounds.width, bounds.height - (HEADER_HEIGHT+FOOTER_HEIGHT)) do
      # within_body(bounds.left , bounds.top - HEADER_HEIGHT, bounds.width, 500) do
        current_document.body
      end

      current_document.repeat :all do
        current_document.footer
      end
      pagination
    end
  end


  # Shared components --------------------------------------------
  
  def header
    svg File.read("#{Rails.root}/app/assets/images/logo.svg"), at: [bounds.left, bounds.top], width: 45
    # bounding_box([bounds.left, bounds.top], width: bounds.width, height: HEADER_HEIGHT) do
    #   bs_row(height: HEADER_HEIGHT) do
    #     svg File.read("#{Rails.root}/app/assets/images/logo.svg"), at: [0,0], width: 45
    #   end
    # end
    # bounding_box([bounds.left, bounds.top], width: bounds.width, height: HEADER_HEIGHT) do
    #   # fill_color "cccccc"
    #   # fill_rectangle [0, bounds.height], bounds.width, bounds.height
    #   svg File.read("#{Rails.root}/app/assets/images/logo.svg"), position: :left, height: 45
    # end
    # move_down 50
  end

  # def footer
  #   bounding_box [bounds.left, bounds.bottom + 60], width: bounds.width, height: 100 do
  #     bs_row do
  #       bs_row(height: 30) do
  #         stroke do
  #           fill_color "322332"
  #           fill_rectangle [0, bounds.height], bounds.width, bounds.height
  #           # reset_font_color

  #         end
  #         text "www.carredor-patrimoine.com - Groupe Carré d'Or Immobilier - 04.72.13.90.00",
  #               size: 7,
  #               align: :center,
  #               valign: :center
  #       end
  #       bs_row(height: 30) do
  #         stroke do
  #           fill_color "000000"
  #           fill_rectangle [0, bounds.height], bounds.width, bounds.height
  #           # reset_font_color
  #         end
  #         text "INFORMATIONS NON CONTRACTUELLES",
  #               size: 7,
  #               align: :center,
  #               color: "ffffff",
  #               valign: :center
  #       end
  #     end
  #     svg File.read("#{Rails.root}/app/assets/images/logo.svg"), at: [40,bounds.bottom + 95], width: 40

  #   end
  # end



  # Footer ----------------------------------------------------------
  def footer
    bounding_box([bounds.left, bounds.bottom + 60], width: 525, height: 100) do
      # fill_color "cccccc"
      # fill_rectangle [0, bounds.height], bounds.width, bounds.height
      stroke do
        stroke_color gray_color
        horizontal_rule
      end
      move_down 8

      bs_row do
        bs_span(6) do
          text = %(Outil issu de La Fabrique du Monde)
          styled_text [text: text], { size: 9 }, align: :left
          styled_text [text: 'www.lafabriquedumonde.fr', link: 'http://mirador-mt.clairezuliani.com/'], { size: 9 }, align: :left
        end       
      end

    end
  end

  def pagination(string = "page <page>", options={}) 
    # string = "page <page> of <total>" if string.blank?
    options = { :at => [bounds.right - 85, bounds.bottom + 50],
                :width => 100,
                :align => :right,
                :start_count_at => 1,
                :color => "333333",
                :size => 8  }
  
    number_pages string, options
  end

  # Helpers ---------------------------------------------------------

  def project_name
    "La Fabrique du Monde"
  end

  # texts : array de strings
  def default_tags(texts)
    highlight = HighlightCallback.new(color: '636c72', document: self)
    content = texts.map do |text|
      [{ text: text, callback: highlight, color: "ffffff", size: 10}, { text: "       "}]
    end
    indent(8) do
      formatted_text content.flatten, :leading => 10
    end
  end

  def default_tag(text)
    highlight = HighlightCallback.new(color: '636c72', document: self)
    formatted_text [ { text: text, callback: highlight } ]
  end
end


class HighlightCallback
  def initialize(options)
    @color = options[:color]
    @document = options[:document]
  end

  def render_behind(fragment)
    original_color = @document.fill_color
    @document.fill_color = @color
    @document.fill_rounded_rectangle(
      [(fragment.left - 8), (fragment.top + 5)], # point d'origine
      fragment.width + 16, fragment.height + 10,  # largeur - hauteur
      7 # corner radius
    )
    @document.fill_color = original_color
  end

end


# callback permettant d'ajouter un fond coloré ("a la" tag boostrap)
# avec espacement pour accueillir une icon devant le fragment de texte.
# A utiliser avec AddIconCallback
class CharTagCallback
  def initialize(options)
    @color = options[:color]
    @document = options[:document]
  end

  def render_behind(fragment)
    original_color = @document.fill_color
    @document.fill_color = @color
    @document.fill_rounded_rectangle(
      [(fragment.left - 28), (fragment.top + 5)], # point d'origine
      fragment.width + 42, fragment.height + 10,  # largeur - hauteur
      7 # corner radius
    )
    @document.fill_color = original_color
  end
end

# Callback permettant d'ajouter une icone devant un fragment de texte
class AddIconCallback
  def initialize(options)
    @document = options[:document]
    @icon = options[:icon]
  end

  def render_in_front(fragment)
    @document.svg File.read("#{Rails.root}/app/assets/images/#{@icon}.svg"), width: 10, :at => [fragment.left - 15, fragment.top + 1]
  end
end
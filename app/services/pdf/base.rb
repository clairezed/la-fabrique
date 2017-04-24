# frozen_string_literal: true

#
# Représente un document PDF généré par l'application.
#
# Cette classe est conçue pour être étendue,
# Elle comporte des helpers pour aider à la mise en page.
#
class Pdf::Base < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(options = {}, &block)
    super options.reverse_merge(margin: [30, 40, 20, 40], page_size: 'A4'), &block
  end

  # surcharger cette méthode pour donner un nom approprié au document.
  #
  def filename
    'pdf_report.pdf'
  end

  def to_pdf
    @rendered_contents ||= begin
      contents
      render
    end
  end

  protected #===================================================================

  # méthode de rendu du contenu du document, à surcharger
  #
  def contents
    raise '#contents is not implemented !'
  end

  # images helpers -------------------------------------------------------------

  def base_image_dir
    @base_image_dir ||= File.join Rails.root, 'app', 'assets', 'images'
  end

  def image_path(*path_components)
    File.join base_image_dir, *path_components
  end

  def icon(path, size = :regular)
    scale = { small: 0.5 }.fetch(size, 0.8)
    image image_path(path), scale: scale
  end

  # layout helpers -------------------------------------------------------------

  # fonctionne "à la" twitter bootstrap 2 .row
  # options :
  # - height : définit une hauteur fixe (nécessaire pour utiliser background_color)
  # - margin : marge gauche / droite
  #            accepte un entier (margin) ou un array (gauche, droite)
  #
  def bs_row(options = {})
    margin = options.fetch(:margin, 0)
    height = options[:height]
    bounds.indent(*margin) do
      bounding_box([0, cursor], width: bounds.width, height: height) do
        yield
        # force le curseur à prendre en compte la b-box imbriquée
        self.y = bounds.absolute_bottom
      end
    end
  end

  # permet de construire des colonnes "à la" twitter bootstrap 2.
  # attention : pas de "retour à la ligne" quand la largeur excède 12
  #
  # params:
  # - factor : largeur, entre 1 et 12
  # - offset : largeur à gauche de ce span, entre 0 et 11
  # - gutter : taille de la gouttière
  #            (doit être la même pour tous les spans d'une row)
  #
  def bs_span(factor = 12, offset = 0, gutter = 5, &block)
    base_width    = (bounds.width - gutter * 11) / 12
    offset_width  = (offset * base_width) + (offset * gutter)
    width         = (factor * base_width) + ((factor - 1) * gutter)
    bounding_box([offset_width, bounds.top], width: width, &block)
  end

  def centered_block(element_width, &block)
    xpos = (bounds.width / 2) - (element_width / 2)
    bounding_box([xpos, bounds.top], width: element_width, &block)
  end

  def h1(*fragments)
    bs_row(height: 50) do
      styled_text fragments,
                  { styles: [:bold], size: 16 },
                  valign: :center
    end
  end

  def h2(*fragments)
    bs_row(height: 40) do
      styled_text fragments, { styles: [:bold], size: 12 }, valign: :center
    end
  end

  def h3(*fragments)
    bs_row(height: 40) do
      styled_text fragments, { size: 12 }, valign: :center
    end
  end

  def paragraph(*fragments)
    basic_text(*fragments)
    move_down 12
  end

  def inline_formatting_paragraph(*fragments)
    inline_formatting_basic_text(*fragments)
    move_down 12
  end

  def basic_text(*fragments)
    bs_row { styled_text fragments, { size: 11 }, align: :justify }
  end

  def inline_formatting_basic_text(*fragments)
    bs_row { styled_text fragments, { size: 11 }, align: :justify, inline_format: true }
  end

  def small(*fragments)
    bs_row { styled_text fragments, size: 9 }
  end

  def small_paragraph(text, margin_bottom = 5)
    basic_text text
    move_down margin_bottom
  end

  def extra_small(*fragments)
    bs_row { styled_text fragments, size: 8, align: :justify }
  end

  def tiny(*fragments)
    bs_row { styled_text fragments, size: 6, align: :justify }
  end

  def highlight(*fragments)
    bs_row { styled_text fragments, {} }
  end

  def small_highlight(*fragments)
    bs_row { styled_text fragments, size: 9 }
  end

  def white_text(*fragments)
    bs_row { styled_text fragments, size: 9 }
  end

  def hr(options = {})
    stroke_color options[:color] if options[:color].present?
    stroke_horizontal_rule
    move_down(12)
  end

  def background_color(color)
    cell background_color:  color,
         width:             bounds.width,
         height:            bounds.height,
         align:             :center,
         borders:           []
  end

  def within_document_boundaries
    bounding_box([bounds.left, bounds.top], width: bounds.width, height: bounds.height) { yield }
  end

  def within_body(left=bounds.left, top=bounds.top, width=bounds.width, height=bounds.height)
    bounding_box([left, top], width: width, height: height) { yield }
  end

  # style helpers --------------------------------------------------------------

  # ajoute du texte au document en lui appliquant un style par défaut
  #
  def styled_text(fragments, style, options = {})
    formatted_text style(fragments, style), options
  end

  # applique un style à un array de strings ou de hashes
  # les styles déjà définis dans un hash restent tels quels
  #
  def style(fragments, style)
    fragments.flat_map do |fragment|
      style_array(fragment).map { |f| style.merge f }
    end
  end

  # convertit un hash ou une string en array de styles.
  # compatible avec les styles inline
  #
  def style_array(fragment)
    return [fragment] if fragment.respond_to?(:to_hash)
    array = ::Prawn::Text::Formatted::Parser.format(fragment.gsub(/\r\n?|\n/, ' '))
    array.map { |h| h.reject { |k, v| v.blank? unless k == :text } }
  end

  # Colors -----------------------------------------------
  def gray_color
    'bbbbbb'
  end

end

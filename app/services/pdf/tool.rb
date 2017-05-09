# frozen_string_literal: true

#
# Gère la génération de PDF à partir d'une facture
#
class Pdf::Tool < Pdf::ProjectBase
  include ToolHelper
  include FormatHelper
  include ApplicationHelper

  attr_reader :tool

  def initialize(tool, options = {}, &block)
    raise ArgumentError, 'expecting a tool object' unless tool.is_a?(Tool)
    super(options, &block)
    @tool = tool
  end

  def filename
    [self.project_name.parameterize, @tool.title.parameterize].join('-') + '.pdf'
  end

  protected #========================================================

  def body
    title
    main_characteristics
    main_content
    side_content
    links
    attachments
  end

  # BLOCKS ===========================================================

  def title
    h1 @tool.title.upcase
    move_down 10
    styled_text [@tool.axis.title.upcase], size: 14, color: axis_color, styles: [:bold]
    move_down 25
  end

  def main_characteristics
    bs_row do
      bs_span(3) do 
        characteristic_tag(tool_group_size(@tool.group_size), 'fa-hourglass')
      end
      bs_span(3, 3) do
        characteristic_tag(tool_duration(@tool.duration), 'fa-users')
      end
      bs_span(3, 6) do 
        characteristic_tag(tool_level(@tool.level), 'fa-signal')
      end
      bs_span(3, 9) do 
        characteristic_tag(@tool.tool_category.title, 'fa-tags')
      end
    end
    move_down 10
    goal
  end

  def main_content
    teaser
    description
    advice
  end

  def side_content
    public
    source
    licence
    material
    tags
    contact
  end


  # ITEMS ===========================================================

  def goal
    h2 'Objectifs'
    styled_text [text: @tool.goal], size: 11
  end

  def teaser
    h2 'Résumé'
    styled_text [text: @tool.teaser], size: 11
  end

  def description
    h2 'Marche à suivre'

    if @tool.steps?
      @tool.steps.each do |step|
        number = { text: leading_zero(step.position), styles: [:bold], size: 26, color: axis_color }
        step_description = { text: step.description, size: 11 }
        formatted_text [number, { text: "  "}, step_description]
        move_down 10
      end
    else
      styled_text [text: @tool.description], size: 11
    end
  end

  def advice
    return if @tool.advice.blank?
    h3 'Conseils'
    styled_text [text: @tool.advice], size: 11
  end

  def public
    return if @tool.public.blank?
    h3 'Public privilégié'
    styled_text [text: @tool.public], size: 11
  end

  def source
    return if @tool.source.blank?
    h3 'Source'
    styled_text [text: @tool.source], size: 11
  end

  def licence
    return if @tool.licence.blank?
    h3 'Copyright'
    styled_text [text: @tool.licence], size: 11
  end

  def material
    return if @tool.material.blank?
    h3 'Matériel'
    styled_text [text: @tool.material], size: 11
  end

  def tags
    return unless @tool.tags.any?
    h3 'Mot-clés'
    default_tags(@tool.tags.pluck(:title))
  end

  def contact
    return unless @tool.display_contact?
    h3 'Proposé par'
    styled_text [text: [@tool.submitter_firstname, @tool.submitter_lastname].compact.join(" ")], size: 11
    styled_text [text: @tool.submitter_organization], size: 11
  end

  def links
    return unless @tool.links.any?
    h3 'Liens'
    @tool.links.each do |link|
      formatted_text [{ text: link.title, size: 11 }]
      formatted_text [text: "#{link.url}", size: 10, color: gray_color]
      move_down 8
    end
  end

  def attachments
    return unless @tool.attachments.any?
    h3 'Media'
    formatted_text [ text: "Documents à télécharger sur la page de l'outil", styles: [:italic], size: 10, color: gray_color ]
    move_down 8
    @tool.attachments.each do |attachment|
      formatted_text [{ text: " - #{attachment.custom_file_name}", size: 11 }]
      move_down 8
    end
  end


  # HELPERS ===========================================================

  def axis_color_line(width = 150, line_width = 4)
    original_line_width = self.line_width
    stroke do
      stroke_color axis_color
      self.line_width = line_width
      horizontal_line 0, width
    end
    self.line_width = original_line_width
  end

  def axis_color
    @axis_color ||= @tool.axis.color[1..-1] # supprimer le diese
  end

  def h1(*fragments)
    styled_text fragments,
                  { styles: [:bold], size: 20 }
    axis_color_line(100)
    # bs_row(height: 60) do
    #   styled_text fragments,
    #               { styles: [:bold], size: 20 },
    #               valign: :center
    # end
    # bs_row(height: 10) do
    #   axis_color_line(100)
    # end
  end

  def h2(*fragments)
    move_down 10
    bs_row(height: 30) do
      styled_text fragments, { styles: [:bold], size: 14 }, valign: :center
    end
    bs_row(height: 10) do
      axis_color_line(100)
    end
  end

  def h3(*fragments)
    move_down 10
    bs_row(height: 25) do
      styled_text fragments, { styles: [:bold], size: 12 }, valign: :center
    end
    bs_row(height: 10) do
      axis_color_line(100)
    end
  end

  def characteristic_tag(text, icon)
    icon_tag = CharTagCallback.new(color: axis_color, document: self)
    add_icon = AddIconCallback.new(document: self, icon: icon)
    formatted_text [ { text: text, callback: [icon_tag, add_icon] } ], 
      color: "ffffff", size: 10, leading: 0, align: :center
  end

  
end

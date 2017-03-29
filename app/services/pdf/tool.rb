#
# Gère la génération de PDF à partir d'une facture
#
class Pdf::Tool < Pdf::Base
  include ToolHelper

  attr_reader :tool

  def initialize(tool, options = {}, &block)
    raise ArgumentError, "expecting a tool object" unless tool.is_a?(Tool)
    super(options, &block)
    @tool = tool
  end

  def filename
    ['MobToolbox', @tool.title.parameterize].join('-') + '.pdf'
  end

  protected #========================================================

  def contents
    current_document = self
    within_body do
      [:header, :characteristics, :description].each do |block|
        current_document.send(block)
      end
    end
    repeat(:all) do
      footer
    end
  end

  # Header ----------------------------------------------------------
  def header
    bs_row do
      h1 @tool.title
    end
    move_down 10
    bs_row do
      bs_span(12) do 
        styled_text [text: @tool.teaser, styles: [:italic]], {size: 12}
      end
    end
    move_down 15
  end

  # characteristics -------------------------------------------------
  def characteristics
    bs_row do
      h2 "Caractéristiques"
    end

    bs_row do
      bs_span(6) do
        styled_text [{text: "Axe : ", styles: [:bold]}, @tool.axis.title], {size: 10}
        move_down 6
        styled_text [{text: "Catégorie : ", styles: [:bold]}, @tool.tool_category.title], {size: 10}
        move_down 6
        styled_text [{text: "Public : ", styles: [:bold]}, tool_public(@tool.public)], {size: 10}
      end
      bs_span(6, 6) do
        styled_text [{text: "Taille du groupe : ", styles: [:bold]}, tool_group_size(@tool.group_size)], size: 10
        move_down 6
        styled_text [{text: "Durée : ", styles: [:bold]}, tool_duration(@tool.duration)], size: 10
        move_down 6
        styled_text [{text: "Niveau de difficultée : ", styles: [:bold]}, tool_level(@tool.level)], size: 10
      end
      move_down 6
    end

    bs_row do
      bs_span(12) do 
        styled_text [{text: "Mots-clés : ", styles: [:bold]}, "motclé1, motclé2, long mots clé numero 3, motmotclé 4"], {size: 10}
      end
    end
  end

  # Description -----------------------------------------------------
  def description
    bs_row do
      h2 "Description"
    end

    bs_row do
      bs_span(12) do
        styled_text [{text: "Objectif : ", styles: [:bold]}, @tool.goal], {size: 10}
        move_down 6
        styled_text [{text: "Description : ", styles: [:bold]}, @tool.description], {size: 10}
        move_down 6
        styled_text [{text: "Matériel : ", styles: [:bold]}, @tool.material], {size: 10}

      end
    end
  end


  # Footer ----------------------------------------------------------
  def footer
    bounding_box([0,60], width: 525, height: 50) do
      stroke do
        stroke_color gray_color
        horizontal_rule
      end
      move_down 8

      bs_row do
        bs_span(6) do
          text = %(Fiche fournie par MobiMagic)
          styled_text [text: text], { size: 9}, align: :left
          styled_text [text: 'www.mobimagic.fr', link: 'http://mirador-mt.clairezuliani.com/'], { size: 9}, align: :left
        end
        bs_span(6, 6) do
          styled_text [ text: "Source :" ], { size: 9}, align: :right
          styled_text [ text: @tool.source, link: @tool.source_url ], { size: 9}, align: :right
        end
        move_down 6
      end

      bs_row do
        bs_span(12) do
          styled_text [text: tool_licence_explanation(@tool.licence)], {styles: [:italic], size: 8}, align: :center
        end
      end
    end
  end



end
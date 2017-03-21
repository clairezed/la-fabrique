module ToolHelper

  # Etat -----------------------------------------------

  def tool_state_title(state)
    I18n.t(state, scope: [:tool_states, :title])
  end

  def tool_state_style(state)
    I18n.t(state, scope: [:tool_states, :style])
  end

  def tool_state_options(states = Tool.states.keys)
    states.map do |state| 
      [tool_state_title(state), state.to_s]
    end
  end

  # Taille groupe -----------------------------------

  def tool_group_size(group_size)
    I18n.t(group_size, scope: [:tool_group_sizes])
  end

  def tool_group_size_options(group_sizes = Tool.group_sizes.keys)
    group_sizes.map do |group_size| 
      [tool_group_size(group_size), group_size.to_s]
    end
  end

  # Durée -------------------------------------------

  def tool_duration(duration)
    I18n.t(duration, scope: [:tool_durations])
  end

  def tool_duration_options(durations = Tool.durations.keys)
    durations.map do |duration| 
      [tool_duration(duration), duration.to_s]
    end
  end

  # Niveau difficulté -------------------------------------------

  def tool_level(level)
    I18n.t(level, scope: [:tool_levels])
  end

  def tool_level_options(levels = Tool.levels.keys)
    levels.map do |level| 
      [tool_level(level), level.to_s]
    end
  end

  # Description type -------------------------------------------

  def tool_description_type_title(type)
    I18n.t(type, scope: [:tool_description_types])
  end  

  # Tool Tag ===============================================================

  def tool_tags_options(tags = Tag.all)
    tags.order(:title).map{|tag| [tag.title, tag.id]}
  end

  # Public cible -------------------------------------------

  # def tool_public(public)
  #   I18n.t(public, scope: [:tool_publics])
  # end

  # def tool_public_options(publics = Tool.publics.keys)
  #   publics.map do |public| 
  #     [tool_public(public), public.to_s]
  #   end
  # end

  # Licence -------------------------------------------

  # def tool_licence(licence)
  #   I18n.t(licence, scope: [:tool_licences, :short])
  # end

  # def tool_licence_explanation(licence)
  #   I18n.t(licence, scope: [:tool_licences, :explanation])
  # end

  # def tool_licence_options(licences = Tool.licences.keys)
  #   licences.map do |licence| 
  #     [tool_licence(licence), licence.to_s]
  #   end
  # end

  # def tool_licence_tooltip(licences = Tool.licences.keys)
  #   array = licences.map do |licence|
  #     [tool_licence(licence), tool_licence_explanation(licence)].join(" : ")
  #   end
  #   raw array.join("</br>")
  # end

end

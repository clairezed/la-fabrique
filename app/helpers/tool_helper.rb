module ToolHelper

  # Etat -----------------------------------------------

  def tool_state_title(state)
    I18n.t(state, scope: [:tool_states, :title])
  end

  def tool_state_style(state)
    I18n.t(state, scope: [:tool_states, :style])
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


end

# frozen_string_literal: true

module AdminHelper
  def submenu(text, sub_menu_array, &block)
    content = block_given? ? capture(&block) : ''
    toggle_class = controller.controller_name.in?(sub_menu_array) ? 'active open' : ''

    content_tag(:li, class: "submenu #{toggle_class}") do
      concat(link_to('#') do
        concat content_tag(:i, '', class: 'fa arrow')
        concat text
      end)
      concat(content_tag(:ul) do
        concat content
      end)
    end
  end
end

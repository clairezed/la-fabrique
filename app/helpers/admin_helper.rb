module AdminHelper
  def submenu(text, sub_menu_array, &block)
    content = block_given? ? capture(&block) : ''
    toggle_class = controller.controller_name.in?(sub_menu_array) ? 'toggled' : ''

    content_tag(:li, class: "submenu #{toggle_class}") do
      concat(link_to('#') do
        concat content_tag(:span, '', class: 'glyphicon glyphicon-plus float-right')
        concat text
      end)
      concat(content_tag(:ul) do
        concat content
      end)
    end
  end
end
module ThemeHelper

  def theme_options(themes = Theme.all)
    themes.order(position: :asc).map do |theme| 
      [theme.title, theme.id]
    end
  end

end

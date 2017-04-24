class AddThemeToBasicPage < ActiveRecord::Migration[5.0]
  def change
    add_reference :basic_pages, :theme, index: true, foreign_key: true
    add_column :basic_pages, :id_key, :string
  end
end

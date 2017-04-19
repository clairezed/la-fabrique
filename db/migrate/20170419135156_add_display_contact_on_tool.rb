class AddDisplayContactOnTool < ActiveRecord::Migration[5.0]
  def change
    add_column :tools, :display_contact, :boolean, default: false
  end
end

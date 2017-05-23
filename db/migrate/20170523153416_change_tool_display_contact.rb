class ChangeToolDisplayContact < ActiveRecord::Migration[5.0]
  def change
    rename_column :tools, :display_contact, :hide_contact
  end
end

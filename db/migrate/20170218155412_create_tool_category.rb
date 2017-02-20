class CreateToolCategory < ActiveRecord::Migration[5.0]
  def change
    create_table :tool_categories do |t|
      t.string :title, null: false
      t.text    :description
      t.integer :position
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end

class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :title
      t.boolean :enabled, default: true
      t.integer :position
      t.timestamps
    end

    create_table :tool_tags do |t|
      t.references  :tool, index: true, foreign_key: true, null: false
      t.references  :tag, index: true, foreign_key: true, null: false
      t.integer :position
      t.timestamps
    end
  end
end

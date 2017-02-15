class CreateBasicPages < ActiveRecord::Migration
  def change
    create_table :basic_pages do |t|
      t.string :title
      t.text :content
      t.integer :position
      t.boolean :enabled, default: false

      t.timestamps null: false
    end
  end
end

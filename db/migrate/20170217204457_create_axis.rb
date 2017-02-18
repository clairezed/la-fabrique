class CreateAxis < ActiveRecord::Migration[5.0]
  def change
    create_table :axes do |t|
      t.references :theme, index: true, foreign_key: true
      t.string :title
      t.text    :description
      t.integer :position
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end

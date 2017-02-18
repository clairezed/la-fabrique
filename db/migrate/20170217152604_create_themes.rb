class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.string :title
      t.integer :position
      t.boolean :enabled, default: false
      t.string :id_key

      t.timestamps
    end
  end
end

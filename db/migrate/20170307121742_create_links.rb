class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.references :tool
      t.string :url
      t.string :title
      t.integer :position
      t.integer :format_type

      t.timestamps
    end
  end
end

class CreateToolHelps < ActiveRecord::Migration[5.0]
  def change
    create_table :tool_helps do |t|
      t.string :field
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end

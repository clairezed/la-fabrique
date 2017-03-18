class ChangeTool < ActiveRecord::Migration[5.0]
  def change

    remove_column :tools, :source_url, :string
    remove_column :tools, :licence, :integer
    remove_column :tools, :public, :integer
    add_column :tools, :licence, :string
    add_column :tools, :public, :string
    add_column :tools, :advice, :text
    add_column :tools, :description_type, :integer, default: 0

    create_table :steps do |t|
      t.references  :tool, index: true, foreign_key: true, null: false
      t.integer :position
      t.text    :description
      t.timestamps
    end
  end
end

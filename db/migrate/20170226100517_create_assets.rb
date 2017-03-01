class CreateAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.references :assetable, polymorphic: true
      t.string :asset_file_name
      t.string :asset_content_type
      t.integer :asset_file_size
      t.string :title
      t.string :alt
      t.integer :position
      t.string :type
      t.string :custom_file_name
      t.integer :format_type

      t.timestamps
    end
  end
end

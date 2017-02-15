class CreateSeos < ActiveRecord::Migration
  def change
    create_table :seos do |t|
      t.string :slug
      t.string :title
      t.string :keywords
      t.text :description
      t.references :seoable, polymorphic: true, index: true
      t.string :param
      
      t.timestamps null: false
    end
  end
end

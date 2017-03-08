class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :tool
      t.string :nickname
      t.text :content
      t.integer     :state, null: false, default: 0
      t.timestamps
    end
  end
end

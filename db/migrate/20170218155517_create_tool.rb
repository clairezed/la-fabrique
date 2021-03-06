class CreateTool < ActiveRecord::Migration[5.0]
  def change
    create_table :tools do |t|
      t.references  :axis, index: true, foreign_key: true, null: false
      t.references  :tool_category, index: true, foreign_key: true, null: false
      t.integer     :state, null: false, default: 0
      t.string      :title
      t.string      :teaser
      t.text        :description
      t.integer     :group_size
      t.integer     :duration
      t.integer     :level
      t.integer     :public
      t.integer     :licence
      t.string      :goal
      t.text        :material
      t.string      :source
      t.string      :source_url
      t.string      :submitter_email

      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end

class CreateTool < ActiveRecord::Migration[5.0]
  def change
    create_table :tools do |t|
      t.references  :axis, index: true, foreign_key: true, null: false
      t.references  :tool_category, index: true, foreign_key: true, null: false
      t.integer     :state, null: false, default: 0
      t.string      :title
      t.text        :description
      t.integer     :group_size, default: 0
      t.integer     :duration, default: 0
      t.integer     :level, default: 0
      t.integer     :public, default: 0
      t.integer     :licence, default: 0
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

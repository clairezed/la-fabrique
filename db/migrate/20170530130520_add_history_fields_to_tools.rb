class AddHistoryFieldsToTools < ActiveRecord::Migration[5.0]
  def change
    add_column :tools, :submitted_snapshot, :jsonb, null: false, default: {}
    add_column :tools, :submitted_at, :datetime
  end
end

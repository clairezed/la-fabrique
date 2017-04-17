class ChangeDescriptionTypeDefault < ActiveRecord::Migration[5.0]
  def up
    change_column_default :tools, :description_type, 1
  end

  def down
    change_column_default :tools, :description_type, 0
  end
end

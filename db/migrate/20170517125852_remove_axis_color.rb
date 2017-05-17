class RemoveAxisColor < ActiveRecord::Migration[5.0]
  def change
    remove_column :axes, :color, :string
  end
end

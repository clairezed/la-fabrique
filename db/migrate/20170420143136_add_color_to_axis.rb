class AddColorToAxis < ActiveRecord::Migration[5.0]
  def change
    add_column :axes, :color, :string
  end
end

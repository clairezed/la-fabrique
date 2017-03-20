class AddIdkeyToAxes < ActiveRecord::Migration[5.0]
  def change
    add_column :axes, :id_key, :string
  end
end

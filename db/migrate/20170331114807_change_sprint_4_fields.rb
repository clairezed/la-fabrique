class ChangeSprint4Fields < ActiveRecord::Migration[5.0]
  def up
    change_column :tools, :teaser, :text
    change_column :tools, :goal, :text
    add_column :tools, :submitter_firstname, :string
    add_column :tools, :submitter_lastname, :string
    add_column :tools, :submitter_organization, :string

    add_column :comments, :organization, :string
  end
  def down
    change_column :tools, :teaser, :string
    change_column :tools, :goal, :string
    remove_column :tools, :submitter_firstname, :string
    remove_column :tools, :submitter_lastname, :string
    remove_column :tools, :submitter_organization, :string

    remove_column :comments, :organization, :string
  end
end

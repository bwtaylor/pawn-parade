class AddRangesToSections < ActiveRecord::Migration
  def up
    add_column :sections, :rating_cap, :integer
    add_column :sections, :grade_min, :integer
    add_column :sections, :grade_max, :integer
  end
end

class AddRangesToSections < ActiveRecord::Migration

  def up
    add_column :sections, :rating_cap, :integer
    add_column :sections, :grade_min, :integer
    add_column :sections, :grade_max, :integer
  end

  def down
    remove_column :sections, :rating_cap
    remove_column :sections, :grade_min
    remove_column :sections, :grade_max
  end

end

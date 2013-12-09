class AddMaxToSections < ActiveRecord::Migration
  def change
    add_column :sections, :max, :integer
  end
end

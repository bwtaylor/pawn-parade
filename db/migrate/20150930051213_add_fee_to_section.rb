class AddFeeToSection < ActiveRecord::Migration
  def change
    add_column :sections, :fee, :decimal, :precision => 8, :scale => 2
  end
end

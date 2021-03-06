class CreateSchedules < ActiveRecord::Migration

  def self.up
    create_table :schedules do |t|
      t.string :slug, :null => false
      t.string :name, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :schedules
  end
  
end

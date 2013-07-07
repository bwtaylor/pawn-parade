class CreateTournaments < ActiveRecord::Migration
  
  def self.up
    create_table :tournaments do |t|
      t.string :location, :null => false
      t.date :event_date, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tournaments
  end
  
end

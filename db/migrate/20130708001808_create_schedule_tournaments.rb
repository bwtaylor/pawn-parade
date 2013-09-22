class CreateScheduleTournaments < ActiveRecord::Migration
  def self.up
    create_table :schedule_tournaments do |t|
      t.integer :schedule_id, :null => false
      t.integer :tournament_id, :null => false
      t.timestamps
    end
    add_index :schedule_tournaments, [:schedule_id, :tournament_id], :unique => true, :name => 'schedule_tournament_index'
  end
  
  def self.down
    drop_table :schedule_tournaments
  end
end

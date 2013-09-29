class CreateTournaments < ActiveRecord::Migration
  
  def self.up
    create_table :tournaments do |t|
      t.string :slug, :null => false
      t.string :name, :null => false
      t.string :location, :null => false
      t.date :event_date, :null => false
      t.string :short_description, :null => false
      t.string :description_asciidoc, :limit => 4000
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tournaments
  end
  
end

class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, :limit => 32
      t.string :slug, :limit => 6
      t.string :full_name, :limit => 64
      t.string :city, :limit => 32
      t.string :county, :limit => 32
      t.string :state, :limit => 2
      t.string :school_district, :limit => 32
      t.string :uscf_affiliate_id, :limit => 12

      t.timestamps
    end
  end
end

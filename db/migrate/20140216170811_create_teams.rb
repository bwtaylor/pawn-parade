class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, :limit => 32
      t.string :slug, :limit => 6

      t.timestamps
    end
  end
end

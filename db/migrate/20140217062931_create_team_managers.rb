class CreateTeamManagers < ActiveRecord::Migration
  def up
    create_table :team_managers do |t|
      t.integer :user_id, :null => false
      t.integer :team_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :team_managers
  end
end

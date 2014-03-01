class CreateGuardians < ActiveRecord::Migration
  def up
    create_table :guardians do |t|
      t.integer :player_id, :null => false
      t.string :email, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :guardians
  end
end

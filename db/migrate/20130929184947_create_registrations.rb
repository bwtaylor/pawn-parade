class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :tournament_id
      t.string :first_name, :limit => 40
      t.string :last_name, :limit => 40
      t.string :school, :limit => 80
      t.string :grade, :limit => 2
      t.string :section, :limit => 40
      t.string :uscf_member_id, :limit => 16
      t.integer :rating
      t.string :status, :limit => 40
      t.decimal :score, :precision=>8, :scale=>1
      t.string :prize, :limit => 40
      t.string :team_prize, :limit => 40

      t.timestamps
    end
  end
end

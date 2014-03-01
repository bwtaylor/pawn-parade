class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name, :limit => 40, :null => false
      t.string :last_name, :limit => 40, :null => false
      t.string :grade, :limit => 2, :null => false
      t.string :school_year, :limit => 10
      t.string :uscf_id, :limit => 10
      t.integer :uscf_rating_reg
      t.integer :uscf_rating_reg_live
      t.string :uscf_status, :limit => 12
      t.date :uscf_expires
      t.date :date_of_birth
      t.string :address, :limit => 80
      t.string :address2, :limit => 80
      t.string :city, :limit => 40
      t.string :state, :limit => 12
      t.string :zip_code, :limit => 10
      t.string :county, :limit => 32
      t.string :gender, :limit => 1
      t.string :school_year, :limit => 10
      t.integer :team_id

      t.timestamps
    end
    add_index  :players, :team_id
  end
end

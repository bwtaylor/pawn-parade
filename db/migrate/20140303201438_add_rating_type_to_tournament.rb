class AddRatingTypeToTournament < ActiveRecord::Migration

  def up
    add_column :tournaments, :rating_type, :string, :limit => 16
  end

  def down
    drop_column :tournaments, :rating_type
  end

end

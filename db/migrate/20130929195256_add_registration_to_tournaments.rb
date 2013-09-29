class AddRegistrationToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :registration, :string, :limit => 8
    add_column :tournaments, :registration_uri, :string
  end
end

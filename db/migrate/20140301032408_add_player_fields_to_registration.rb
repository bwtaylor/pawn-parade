class AddPlayerFieldsToRegistration < ActiveRecord::Migration
  def up
    add_column :registrations, :player_id, :integer
    add_column :registrations, :guardian_emails, :string, :limit => 512
    add_column :registrations, :date_of_birth, :date
    add_column :registrations, :address, :string, :limit => 80
    add_column :registrations, :city, :string, :limit => 40
    add_column :registrations, :state, :string, :limit => 12
    add_column :registrations, :zip_code, :string, :limit => 10
    add_column :registrations, :county, :string, :limit => 32
    add_column :registrations, :gender, :string, :limit => 1
    add_column :registrations, :team_slug, :string, :limit => 6
  end

  def down
    remove_column :registrations, :player_id
    remove_column :registrations, :guardian_emails
    remove_column :registrations, :date_of_birth
    remove_column :registrations, :address, :string
    remove_column :registrations, :city, :string
    remove_column :registrations, :state, :string
    remove_column :registrations, :zip_code, :string
    remove_column :registrations, :county, :string
    remove_column :registrations, :gender, :string
    remove_column :registrations, :team_slug, :string
  end
end

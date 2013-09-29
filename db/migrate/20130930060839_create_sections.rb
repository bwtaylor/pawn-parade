class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :tournament_id, :null => false
      t.string :name, :limit => 80, :null => false
      t.string :slug, :limit => 80, :null => false
      t.boolean :rated, :null => false
      t.string :status, :limit => 40, :null => false

      t.timestamps
    end
  end
end

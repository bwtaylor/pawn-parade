class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :entity_class, :limit => 32
      t.integer :target_id
      t.string :tag, :limit => 32

      t.timestamps
    end
  end
end

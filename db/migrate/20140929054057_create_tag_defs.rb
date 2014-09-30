class CreateTagDefs < ActiveRecord::Migration
  def change
    create_table :tag_defs do |t|
      t.string :entity_class, :limit => 32
      t.string :tag, :limit => 32
      t.string :meaning, :limit => 80

      t.timestamps
    end
  end
end

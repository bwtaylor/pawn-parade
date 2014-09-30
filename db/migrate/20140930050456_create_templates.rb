class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name, :limit => 48
      t.string :body, :limit => 4000
      t.string :base_class, :limit => 32
      t.string :content_type, :limit => 32

      t.timestamps
    end
  end
end

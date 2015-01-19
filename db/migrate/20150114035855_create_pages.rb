class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :slug, :limit => 255
      t.string :page_type, :limit => 32
      t.string :syntax, :limit => 24
      t.string :content, :limit => 4000
      t.string :source, :limit => 255

      t.timestamps
    end
  end
end

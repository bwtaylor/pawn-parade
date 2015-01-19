class AddFeeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :fee, :decimal, :precision => 8, :scale => 2
  end
end

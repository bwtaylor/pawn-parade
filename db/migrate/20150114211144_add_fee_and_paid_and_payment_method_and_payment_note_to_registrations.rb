class AddFeeAndPaidAndPaymentMethodAndPaymentNoteToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :fee, :decimal, :precision => 6, :scale => 2
    add_column :registrations, :paid, :decimal, :precision => 6, :scale => 2
    add_column :registrations, :payment_method, :string, :limit => 24
    add_column :registrations, :payment_note, :string, :limit => 48
  end
end

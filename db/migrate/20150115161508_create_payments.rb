class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :txn_id, :limit => 24
      t.datetime :payment_date
      t.decimal :amount, :precision => 6, :scale => 2
      t.string :payer_email, :limit => 64
      t.string :first_name, :limit => 32
      t.string :last_name, :limit => 32
      t.string :receiver_email, :limit => 64
      t.decimal :fee, :precision => 6, :scale => 2
      t.string :payment_status, :limit => 24
      t.string :transaction_subject, :limit => 128
      t.integer :num_cart_items
      t.string :payer_id, :limit => 16
      t.string :receiver_id, :limit => 16
      t.string :ipn_track_id, :limit => 16
      t.string :verify_sign, :limit => 64
      t.string :address_street, :limit => 128
      t.string :address_city, :limit => 32
      t.string :address_state, :limit => 6
      t.string :address_zip, :limit => 12
      t.string :address_country_code, :limit => 8
      t.integer :event_id
      t.string :raw_body, :limit => 4000
      t.string :ipn_status, :limit => 16

      t.timestamps
    end
  end
end

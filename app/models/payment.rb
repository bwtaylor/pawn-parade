class Payment < ActiveRecord::Base
  attr_accessible :address_city, :address_country_code, :address_state, :address_street,
                  :address_zip, :amount, :event_id, :fee, :first_name, :ipn_status, :ipn_track_id,
                  :last_name, :num_cart_items, :payer_email, :payer_id, :payment_status,
                  :payment_date, :raw_body, :receiver_email, :receiver_id,
                  :transaction_subject, :txn_id, :verify_sign

  def process?
    !self.new_record? and
        payment_status == 'Completed' and
        Payment.find_all_by_txn_id_and_payment_status(self.txn_id,'Completed').size == 1  and
        self.receiver_email == ENV['PAYPAL_MERCHANT']
  end

end

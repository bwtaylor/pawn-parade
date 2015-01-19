require 'net/http'
require 'uri'

class PaymentsController < ApplicationController

  protect_from_forgery :except => [:paypal_ipn_callback]

  #  :address_city, :address_country_code, :address_state, :address_street,
  #  :address_zip, :amount, :event_id, :fee, :first_name, :ipn_status, :ipn_track_id,
  #  :last_name, :num_cart_items, :payer_email, :payer_id, :payment_status,
  #  :payment_date, :raw_body, :receiver_email, :receiver_id,
  #  :transaction_subject, :txn_id, :verify_sign

  def paypal_ipn_callback
    response = validate_IPN_notification(request.raw_post)
    payment = Payment.new(
        :txn_id => params[:txn_id],
        :payment_date=>decode_date(params[:payment_date]),
        :amount=>params[:mc_gross],
        :payer_email => CGI::unescape(params[:payer_email]),
        :last_name => params[:last_name],
        :first_name => params[:first_name],
        :receiver_email => CGI::unescape(params[:receiver_email]),
        :fee => params[:mc_fee],
        :payment_status => params[:payment_status],
        :transaction_subject => params[:custom],
        :num_cart_items => params[:num_cart_items],
        :payer_id => params[:payer_id],
        :receiver_id => params[:receiver_id],
        :ipn_track_id => params[:ipn_track_id],
        :verify_sign => params[:verify_sign],
        :address_street => params[:address_street],
        :address_city => params[:address_city],
        :address_state => params[:address_state],
        :address_zip => params[:address_zip],
        :address_country_code => params[:address_country_code],
        :event_id => /.*\[(.*)\]/.match(params[:custom])[1].to_i,
        :raw_body => request.raw_post,
        :ipn_status => response
    )
    payment.save!

    process_payment if response == 'VERIFIED' and payment.process?
    render :nothing => true
  end

  def process_payment
    num_cart_items = params[:num_cart_items].to_i
    (1..num_cart_items).each do |n|
      item_number = params["item_number#{n}".to_sym].to_i
      paid = params["mc_gross_#{n}".to_sym].to_f
      r = Registration.find(item_number)
      puts "PAID: #{r.first_name} #{r.last_name} for #{paid}"
      r.paid ||= 0.00
      r.paid += paid
      r.save!
    end
  end

  def validate_IPN_notification(raw)
    endpoint = Rails.env == 'production' ? 'www.paypal.com' : 'www.sandbox.paypal.com'
    uri = URI.parse("https://#{endpoint}/cgi-bin/webscr?cmd=_notify-validate")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    http.post(uri.request_uri, raw, 'Content-Length' => "#{raw.size}", 'User-Agent' => "PawnParade").body
  end

  def decode_date(encoded_date)
    DateTime.parse(CGI::unescape(encoded_date))
  end

end
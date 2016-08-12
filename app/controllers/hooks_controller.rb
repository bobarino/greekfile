class HooksController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :check_subdomain

    Stripe.api_key = "sk_test_9pzYmI7SZ6vUBbnjOTLJoLIx"

     def receiver
      request.body.rewind
      data_json = JSON.parse request.body.read

      p data_json['type']

      if data_json['type'] == "invoice.payment_succeeded"
        make_active(data_json['data']['object']['customer'])
      end

      if data_json['type'] == "invoice.payment_failed"
        make_inactive(data_json['data']['object']['customer'])
      end

      if data_json['type'] == "customer.created"
        make_customer(data_json['data']['object']['sources']['data'][0]['name'], data_json['data']['object']['id'])
      end
      render nothing: true, status: 200
    end

    def make_active(cust)
      user = User.where(stripe_cust_id: cust).first
      user.active = true
      user.save!
    end

    def make_inactive(cust)
      user = User.where(stripe_cust_id: cust).first
      user.active = false
      user.save!
    end

    def make_customer(email, id)
      user = User.where(email: email).first
      user.stripe_cust_id = id
      user.active = true
      user.save!
    end
end

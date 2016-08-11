class HooksController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :check_subdomain

    Stripe.api_key = "sk_test_9pzYmI7SZ6vUBbnjOTLJoLIx"

     def receiver
      request.body.rewind
      data_json = JSON.parse request.body.read

      p data_json['data']['object']['customer']
      p data_json['type']

      if data_json['type'] == "invoice.payment_succeeded"
        make_active()
      end

      if data_json['type'] == "invoice.payment_failed"
        make_inactive()
      end

      if data_json['type'] == "customer.created"
        make_customer(data_json['data']['object']['id'])
      end
      render nothing: true, status: 200
    end

    def make_active
      user = User.find(session[:current_user_id])
      user.username = "success"
      user.save!
    end

    def make_inactive
      p "failure"
    end

    def make_customer(id)
      user = User.find(session[:current_user_id])
      user.stripe_cust_id = id
      user.save!
    end
end

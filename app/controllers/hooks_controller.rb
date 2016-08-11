class HooksController < ApplicationController
  require 'json'

    Stripe.api_key = "sk_test_9pzYmI7SZ6vUBbnjOTLJoLIx"

    def receiver
      request.body.rewind
      data_json = JSON.parse request.body.read

      p data_json['data']['object']['customer']

      if data_json[:type] == "invoice.payment_succeeded"
        make_active(data_event)
      end

      if data_json[:type] == "invoice.payment_failed"
        make_inactive(data_event)
      end
    end

    def make_active(data_event)
      current_user.username = "success"
    end

    def make_inactive(data_event)
      current_user.username = "failure"
    end
end

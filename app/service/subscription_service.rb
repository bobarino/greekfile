class SubscriptionService

  def initialize(data)
    @data = data
  end

  def process_data
   request.body.rewind
   @data = JSON.parse request.body.read

   p @data['type']

   if @data['type'] == "invoice.payment_succeeded"
     make_active(@data['data']['object']['customer'])
   end

   if @data['type'] == "invoice.payment_failed"
     make_inactive(@data['data']['object']['customer'])
   end

   if @data['type'] == "customer.created"
     make_customer(@data['data']['object']['sources']['data'][0]['name'], @data['data']['object']['id'], @data['data']['object']['subscriptions']['data'][0]['id'])
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
    ChargesController.unsubscribe
  end

  def make_customer(email, cust_id, sub_id)
    user = User.where(email: email).first
    user.stripe_cust_id = cust_id
    user.stripe_sub_id = sub_id
    user.save!
  end

end

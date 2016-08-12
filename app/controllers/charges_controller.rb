class ChargesController < ApplicationController
  def new
    if current_user.active?
      redirect_to manage_path and return
    end
  end

  def create

    customer = Stripe::Customer.create(
      :plan => "std",
      :email => params[:email],
      :source  => params[:stripeToken]
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def manage
  end

  def unsubscribe
    sub = Stripe::Subscription.retrieve(current_user.stripe_sub_id)
    sub.delete
    user = current_user
    current_user.active = false
    current_user.save!
  end
end

class ChargesController < ApplicationController
  def new
  end

  def create
    session[:current_user_id] = current_user.id
    # Amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      :plan => "std",
      :email => params[:email],
      :source  => params[:stripeToken]
    )
    p customer

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end

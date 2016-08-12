class ChargesController < ApplicationController
  def new
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
end

require "stripe"
Stripe.api_key = "sk_test_T0amMUYh7st1EN19UWKSmHKP"

class StripesController < ApplicationController
  def index
    # Stripe::Customer.all
    @plans = Stripe::Plan.all
  end
end

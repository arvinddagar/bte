class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def new
  end

  def create
  # Amount in cents
    @amount = 500

    customer = Stripe::Customer.create(
      email: 'example@stripe.com',
      card:  params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      @amount,
      description: 'Rails Stripe customer',
      currency:    'usd'
    )

   rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def purchase_params
      params[:purchase]
    end
end

class PurchasesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PaymentsHelper

  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def new
    @purchase = Purchase.new
    @lesson = Lesson.friendly.find(params[:lesson])
  end

  def create
    @lesson = Lesson.friendly.find(params[:lesson_id])
    customer = Stripe::Customer.create(
      email: current_user.email,
      card:  params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      @lesson.amount * 100,
      description: "Lesson Purchase Lesson Id: #{@lesson.id} Name #{lesson.name}",
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

# /app/helpers/payments_helper.rb
module PaymentsHelper
  def stripe_script_attrs(payment)
    cost = 100
    description = "Purchase Summary Cost 100 Count 1"
     as_html_data(
       key: ENV['STRIPE_PUBLISHABLE_KEY'],
       amount: (100*100).to_i.to_s,
       name: "Bte",
       description: description,
       image: image_path('stripe-checkout-icon.png'),
     ).merge(src: "https://checkout.stripe.com/v2/checkout.js",
             class: "stripe-button")
  end
end

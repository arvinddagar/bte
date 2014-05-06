# /app/models/purchase.rb
class Purchase < ActiveRecord::Base
  PAYMENT_METHODS = {
    stripe: 'stripe'
  }
end

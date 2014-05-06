# /app/models/coupon.rb
class Coupon < ActiveRecord::Base
  before_create { self.code = code.upcase }
end

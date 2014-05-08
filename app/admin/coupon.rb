# /app/admin/coupon.rb
ActiveAdmin.register Coupon do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    coupon: [:code, :description, :start_date, :end_date,
                             :discount_percentage, :multiple_use]
    end
  end
end

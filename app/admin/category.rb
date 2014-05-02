# /app/admin/category.rb
ActiveAdmin.register Category do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
          category: [:category_name, :parent_id]
    end
  end

end

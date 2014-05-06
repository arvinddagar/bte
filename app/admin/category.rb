# /app/admin/category.rb
ActiveAdmin.register Category do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    category: [:category_name, :parent_id]
    end
  end
end

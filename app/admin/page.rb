ActiveAdmin.register Page do
  before_filter only: [:show, :edit] do
    @page = Page.find_by(permalink: params[:id])
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :permalink
      f.input :pages_type, as: :select, collection: Page::PAGES_TYPE
      f.input :content, as: :html_editor
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit :utf8, :_method, :_wysihtml5_mode, :authenticity_token, :commit, :id,
          page: [:name, :permalink, :content, :pages_type]
    end
  end

end
ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :name
      f.input :permalink
      f.input :content, as: :html_editor
    end
    f.actions
  end
end
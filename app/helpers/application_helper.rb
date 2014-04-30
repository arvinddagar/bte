# /app/helpers/application_helper.rb
module ApplicationHelper
  def as_html_data(hash)
    data = {}
    hash.each do |k, v|
      data["data-#{k.to_s.gsub('_', '-')}"] = v
    end
    data
  end

  def app_data
    as_html_data(
      view:       javascript_view_name,
      debug:      !Rails.env.production?
    )
  end

  def current_user_data
    return {} unless current_user
    as_html_data(
      type:   current_user.type,
      id:     current_user.id
    )
  end

  def javascript_view_name
    @javascript_view_name ||= "#{controller_path.camelcase.gsub('::', '_')}.#{action_name.camelcase}View"
  end
end

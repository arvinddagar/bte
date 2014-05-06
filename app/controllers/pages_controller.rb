# /app/controllers/pages_controller.rb
class PagesController < ApplicationController
  before_action :set_page, only: [:show]

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find_by(permalink: params[:id])
  end
end

# /app/controllers/tutor_statements_controller.rb
class TutorStatementsController < ApplicationController
  before_action :load_tutor

  def show
    statement = @tutor.statements.published.find_by_id(params[:id])
    if statement
      statement
    else
      not_found
    end
  end

  private

  def load_tutor
    @tutor = current_user.tutor
  end
end

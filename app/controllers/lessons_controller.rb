# /app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @lessons               = []
      @lessons               = Lesson.search(params[:search])
      lessons_based_location = Lesson.near(params[:search])
      if  lessons_based_location.length > 0
        lessons_based_location.each do |lesson|
          @lessons << lesson
        end
      end
    else
      @lessons = Lesson.order(:address).page params[:page]
    end
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = current_user.tutor.lessons.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to lesson_time_slots_path(@lesson), notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url }
      format.json { head :no_content }
    end
  end

  def sub_category
    @subcategory = Category.where(parent_id: params[:parent_id])
    render partial: 'subcategory', layout: false, locals: { subcategory: @subcategory }
  end

  private

  def set_lesson
    @lesson = Lesson.friendly.find(params[:id])
  end

  def lesson_params
    attrs = []
    attrs.push(:category_id)
    attrs.push(*Lesson::COMPLETE_ATTRIBUTES)
    params.require(:lesson).permit(attrs)
  end
end

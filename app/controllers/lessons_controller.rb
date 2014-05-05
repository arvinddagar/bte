# /app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @lessons = []
      @lessons = Lesson.search(params[:search])
      lessons_based_location = Lesson.near(params[:search])
      if  lessons_based_location.length > 0
        lessons_based_location.each do |lesson|
          @lessons << lesson
        end
      end
    else
      @lessons = Lesson.order(:location).page params[:page]
    end
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = current_user.tutor.lessons.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
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

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url }
      format.json { head :no_content }
    end
  end

  def sub_category
    @subcategory = Category.where(parent_id: params[:parent_id])
    render partial: 'subcategory' ,layout: false, locals: { subcategory: @subcategory }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      attrs = []
      attrs.push(:category_id)
      attrs.push(*Lesson::COMPLETE_ATTRIBUTES)
      params.require(:lesson).permit(attrs)
    end
end

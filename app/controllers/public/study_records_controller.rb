class Public::StudyRecordsController < ApplicationController
  def index
    @study_records = StudyRecord.all
  end

  def show
    @study_record = StudyRecord.find(params[:id])
  end

  def create
  end

  def edit
    @study_record = StudyRecord.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def study_record_params
      params.require(:study_record).permit(:study_theme_id)
  end

  def study_theme_params
    params.require(:study_theme).permit(:study_category_id, :theme_title, :theme_body, :theme_color)
  end

end

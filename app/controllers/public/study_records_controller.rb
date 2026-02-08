class Public::StudyRecordsController < ApplicationController
  def index
    @study_record = StudyRecord.all
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
end

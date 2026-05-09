class Admin::StudyRecordsController < ApplicationController

  layout "admin"
  
  def index
    @study_records = StudyRecord.order(created_at: :desc)
    @finished_records = @study_records.where.not(ended_at: nil)
  end

  def destroy
    @study_record = StudyRecord.find(params[:id])
    @study_record.destroy
    redirect_to admin_study_records_path
  end
  
end

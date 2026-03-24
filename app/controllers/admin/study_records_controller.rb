class Admin::StudyRecordsController < ApplicationController
  layout "admin"
  def index
    @study_records = StudyRecord.all
  end

  def destroy
    @study_record = StudyRecord.find(params[:id])
    @study_record.destroy
    redirect_to admin_study_records_path
  end
end

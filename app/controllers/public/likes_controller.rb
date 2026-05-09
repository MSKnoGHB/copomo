class Public::LikesController < ApplicationController
  def create
    study_record = StudyRecord.find(params[:study_record_id])
    like = current_user.likes.new(study_record_id: study_record.id)
    like.save
    case params[:redirect_to]
    when "show"
      redirect_to public_study_record_path(study_record)
    when "timeline"
      redirect_to public_study_records_path
    else
      redirect_to public_root_path
    end
  end

  def destroy
    study_record = StudyRecord.find(params[:study_record_id])
    like = current_user.likes.find_by(study_record_id: study_record.id)
    like.destroy
    case params[:redirect_to]
    when "show"
      redirect_to public_study_record_path(study_record)
    when "timeline"
      redirect_to public_study_records_path
    else
      redirect_to public_root_path
    end
  end
end

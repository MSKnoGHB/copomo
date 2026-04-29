class Public::CommentsController < ApplicationController
  def create
    @study_record = StudyRecord.find(params[:study_record_id])
    @comment = @study_record.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to public_study_record_path(@study_record), notice: "コメントを投稿しました"
    else
      @room = @study_record.room.room_name
      @study_category = @study_record.study_theme.study_category.category_title
      @study_theme = @study_record.study_theme.theme_title
      @started_at = @study_record.started_at.strftime("%Y/%m/%d %H:%M:%S")
      @ended_at = @study_record.ended_at.strftime("%Y/%m/%d %H:%M:%S")
      @total_focus_minutes = @study_record.total_focus_minutes
      @record_body = @study_record.record_body
      @study_intervals = @study_record.study_intervals
      @comments = @study_record.comments.all
      render "public/study_records/show"
    end
  end

  def destroy
    @study_record = StudyRecord.find(params[:study_record_id])
    @comment = @study_record.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to public_study_record_path(@study_record), notice: "コメントを削除しました"
    else
      render "public/study_records/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end

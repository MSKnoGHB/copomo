class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @study_records = User.search_for(@content, @method) 
    else
      @study_records = StudyRecord.search_for(@content, @method)
    end
  end
end

class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "user"
      @records = User.search_for(@content, @method) 
    else
      @records = StudyTheme.search_for(@content, @method)
    end
  end
end

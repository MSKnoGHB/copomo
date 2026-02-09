class Public::StudyThemesController < ApplicationController
  def index
    @study_themes = StudyTheme.all
  end

  def create
    @study_theme = StudyTheme.new
  end

  def edit
    @study_theme = StudyTheme.find(params[:id])
  end

  def update
  end

  
end

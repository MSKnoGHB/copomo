class Public::StudyThemesController < ApplicationController
  def index
    @study_theme = StudyTheme.all
  end

  def create
  end

  def edit
    study_theme = StudyTheme.find(params[:id])
  end

  def update
  end
end

class Admin::StudyCategoriesController < ApplicationController
  layout "admin"

  def create
    study_category = StudyCategory.new(study_category_params)
    if study_category.save
      redirect_to admin_study_categories_path
    else
      render :index
    end
  end

  def edit
    @study_category = StudyCategory.find(params[:id])
  end

  def index
    @study_categories = StudyCategory.all
    @study_category = StudyCategory.new
  end

  def update
    study_category = StudyCategory.find(params[:id])
    if study_category.update(study_category_params)
      redirect_to admin_study_categories_path
    else
      render :edit
    end
  end

  def activate
    study_category = StudyCategory.find(params[:id])
    if study_category.is_active?
      study_category.update(is_active: false)
    else
      study_category.update(is_active: true)
    end
      redirect_to admin_study_categories_path
  end

  private
  def study_category_params
    params.require(:study_category).permit(:category_title, :category_body, :is_active)
  end
  
end

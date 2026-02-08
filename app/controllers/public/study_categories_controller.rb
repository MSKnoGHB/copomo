class Public::StudyCategoriesController < ApplicationController
  def index
    @study_categories = StudyCategory.all
  end
end

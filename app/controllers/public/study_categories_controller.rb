class Public::StudyCategoriesController < ApplicationController
  def index
    @study_category = StudyCategory.all
  end
end

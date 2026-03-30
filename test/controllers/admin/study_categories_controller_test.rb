require "test_helper"

class Admin::StudyCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_study_categories_index_url
    assert_response :success
  end
end

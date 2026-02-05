require "test_helper"

class Public::StudyCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_study_categories_index_url
    assert_response :success
  end
end

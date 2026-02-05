require "test_helper"

class Public::StudyThemesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_study_themes_index_url
    assert_response :success
  end

  test "should get create" do
    get public_study_themes_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_study_themes_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_study_themes_update_url
    assert_response :success
  end
end

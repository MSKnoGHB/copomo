require "test_helper"

class Public::StudyRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_study_records_index_url
    assert_response :success
  end

  test "should get show" do
    get public_study_records_show_url
    assert_response :success
  end

  test "should get create" do
    get public_study_records_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_study_records_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_study_records_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_study_records_destroy_url
    assert_response :success
  end
end

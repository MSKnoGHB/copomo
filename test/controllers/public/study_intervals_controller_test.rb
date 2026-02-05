require "test_helper"

class Public::StudyIntervalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_study_intervals_index_url
    assert_response :success
  end

  test "should get create" do
    get public_study_intervals_create_url
    assert_response :success
  end

  test "should get update" do
    get public_study_intervals_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_study_intervals_destroy_url
    assert_response :success
  end
end

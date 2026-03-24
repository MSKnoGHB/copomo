require "test_helper"

class Admin::StudyRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_study_records_index_url
    assert_response :success
  end
end

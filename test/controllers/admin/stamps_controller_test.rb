require "test_helper"

class Admin::StampsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_stamps_edit_url
    assert_response :success
  end

  test "should get index" do
    get admin_stamps_index_url
    assert_response :success
  end
end

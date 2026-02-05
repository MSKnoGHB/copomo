require "test_helper"

class Public::StampsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_stamps_index_url
    assert_response :success
  end
end

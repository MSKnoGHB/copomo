require "test_helper"

class Public::ChatLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_chat_logs_create_url
    assert_response :success
  end
end

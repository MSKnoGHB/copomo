require "test_helper"

class ChatLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get chat_logs_create_url
    assert_response :success
  end
end

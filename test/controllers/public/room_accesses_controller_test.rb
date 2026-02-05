require "test_helper"

class Public::RoomAccessesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_room_accesses_create_url
    assert_response :success
  end

  test "should get update" do
    get public_room_accesses_update_url
    assert_response :success
  end
end

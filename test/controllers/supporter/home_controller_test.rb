require "test_helper"

class Supporter::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get supporter_home_index_url
    assert_response :success
  end
end

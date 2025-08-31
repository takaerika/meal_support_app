require "test_helper"

class Patient::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get patient_home_index_url
    assert_response :success
  end
end

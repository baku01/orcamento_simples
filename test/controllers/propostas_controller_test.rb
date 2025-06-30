require "test_helper"

class PropostasControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get propostas_new_url
    assert_response :success
  end
end

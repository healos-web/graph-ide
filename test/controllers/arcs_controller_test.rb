require 'test_helper'

class ArcsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get arcs_new_url
    assert_response :success
  end

  test "should get create" do
    get arcs_create_url
    assert_response :success
  end

  test "should get update" do
    get arcs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get arcs_destroy_url
    assert_response :success
  end

end

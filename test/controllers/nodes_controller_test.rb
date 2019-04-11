require 'test_helper'

class NodesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get nodes_new_url
    assert_response :success
  end

  test "should get create" do
    get nodes_create_url
    assert_response :success
  end

  test "should get update" do
    get nodes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get nodes_destroy_url
    assert_response :success
  end

end

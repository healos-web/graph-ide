require 'test_helper'

class GraphControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get graph_new_url
    assert_response :success
  end

  test "should get create" do
    get graph_create_url
    assert_response :success
  end

  test "should get update" do
    get graph_update_url
    assert_response :success
  end

  test "should get destroy" do
    get graph_destroy_url
    assert_response :success
  end

  test "should get create_several" do
    get graph_create_several_url
    assert_response :success
  end

end

require 'test_helper'

class BoardsControllerTest < ActionController::TestCase
  test "should get draft" do
    get :draft
    assert_response :success
  end

  test "should get adp" do
    get :adp
    assert_response :success
  end

  test "should get points" do
    get :points
    assert_response :success
  end

end

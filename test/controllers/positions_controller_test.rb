require 'test_helper'

class PositionsControllerTest < ActionController::TestCase
  test "should get qb" do
    get :qb
    assert_response :success
  end

  test "should get rb" do
    get :rb
    assert_response :success
  end

  test "should get wr" do
    get :wr
    assert_response :success
  end

  test "should get te" do
    get :te
    assert_response :success
  end

  test "should get def" do
    get :def
    assert_response :success
  end

  test "should get k" do
    get :k
    assert_response :success
  end

end

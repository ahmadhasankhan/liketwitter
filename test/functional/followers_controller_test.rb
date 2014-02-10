require 'test_helper'

class FollowersControllerTest < ActionController::TestCase
  setup do
    @follower = followers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:followers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create follower" do
    assert_difference('Follower.count') do
      post :create, :follower => @follower.attributes
    end

    assert_redirected_to follower_path(assigns(:follower))
  end

  test "should show follower" do
    get :show, :id => @follower.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @follower.to_param
    assert_response :success
  end

  test "should update follower" do
    put :update, :id => @follower.to_param, :follower => @follower.attributes
    assert_redirected_to follower_path(assigns(:follower))
  end

  test "should destroy follower" do
    assert_difference('Follower.count', -1) do
      delete :destroy, :id => @follower.to_param
    end

    assert_redirected_to followers_path
  end
end

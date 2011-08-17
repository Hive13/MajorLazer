require 'test_helper'

class TimeBalancesControllerTest < ActionController::TestCase
  setup do
    @time_balance = time_balances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_balances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_balance" do
    assert_difference('TimeBalance.count') do
      post :create, :time_balance => @time_balance.attributes
    end

    assert_redirected_to time_balance_path(assigns(:time_balance))
  end

  test "should show time_balance" do
    get :show, :id => @time_balance.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @time_balance.to_param
    assert_response :success
  end

  test "should update time_balance" do
    put :update, :id => @time_balance.to_param, :time_balance => @time_balance.attributes
    assert_redirected_to time_balance_path(assigns(:time_balance))
  end

  test "should destroy time_balance" do
    assert_difference('TimeBalance.count', -1) do
      delete :destroy, :id => @time_balance.to_param
    end

    assert_redirected_to time_balances_path
  end
end

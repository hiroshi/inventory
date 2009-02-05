require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  test "index" do
    login_as :quentin
    get :index
    assert_response :success

    assert_operator 0, :<, assigns(:assets).size
  end

  test "new" do
    login_as :quentin
    get :new
    assert_response :success
  end

  test "create and show" do
    login_as :quentin
    post :create, :asset => {:developer_name => developers(:apple).name, :product_name => "PowerBook"}
    assert_valid assigns(:asset)
    assert_redirected_to assets_path

    get :show, :id => assigns(:asset).id
    assert_response :success
    assert_equal 1, assigns(:asset).utilizations.size
  end

  test "show" do
    login_as :quentin
    get :show, :id => assets(:macbook).id
    assert_response :success
  end

  test "update" do
    assert_equal "MacBook", assets(:macbook).product_name

    login_as :quentin
    put :update, :id => assets(:macbook).id, :asset => {:product_name => "MacBook Pro"}
    assert_redirected_to assets_path

    assert_equal "MacBook Pro", assets(:macbook, true).product_name
  end

  test "destroy" do
    login_as :quentin
    delete :destroy, :id => assets(:macbook).id
    assert_redirected_to assets_path

    assert_raise(ActiveRecord::RecordNotFound){ assets(:macbook, true) }
  end

  test "auto_complete_for_asset_developer_name" do
    login_as :quentin
    get :auto_complete_for_asset_developer_name, :asset => {:developer_name => "app"}
    assert_response :success

    assert assigns(:developers).include?(developers(:apple))
    assert !assigns(:developers).include?(developers(:panasonic))
  end
end

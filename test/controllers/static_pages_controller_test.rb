require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "homeページにアクセスできる" do
    get :home
    assert_response :success
    assert_select "title", "Home | Ruby on Rails Tutorial Test App"
  end

  test "helpページにアクセスできる" do
    get :help
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Test App"
  end
  
  test "aboutページにアクセスできる" do
    get :about
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Test App"
  end
end

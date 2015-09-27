require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @base_title = "Ruby on Rails Tutorial Test App"
  end
  
  test "新規登録ページにアクセスできる" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end
end
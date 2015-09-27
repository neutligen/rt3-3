require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "新規登録ページにアクセスできる" do
    get :new
    assert_response :success
  end

end

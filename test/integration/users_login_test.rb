require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "ログインエラーのメッセージはログインエラー直後の画面にのみ表示する" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "   ", password: "  " }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "正しい組み合わせであればログイン可能/ログインしていればログアウトも可能" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # ２番目のウィンドウでログアウトをクリックするユーザをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "「ログインしたままにする」を選択した場合はcookiesを発行する" do
    log_in_as(@user, remember_me: '1')
    assert_equal "Michael Example", assigns(:user).name
  end
  
  test "「ログインしたままにする」を選択しなかった場合はcookiesを発行しない" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end

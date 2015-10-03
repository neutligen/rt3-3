require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "ログインしていない場合、ホームページに各種リンクが存在する" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", 'http://www.railstutorial.org/', count: 2
    assert_select "a[href=?]", 'http://news.railstutorial.org/'
    assert_select "a[href=?]", 'http://rubyonrails.org/'
    assert_select "a[href=?]", 'http://www.michaelhartl.com/'
  end
  
  test "ログインしていた場合、対応するリンクが全て存在する"do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", 'http://www.railstutorial.org/', count: 2
    assert_select "a[href=?]", 'http://news.railstutorial.org/'
    assert_select "a[href=?]", 'http://rubyonrails.org/'
    assert_select "a[href=?]", 'http://www.michaelhartl.com/'
  end
end

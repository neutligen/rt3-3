require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup
    @user = users(:michael)
    remember(@user)
  end
  
  test "「ログインしたまま」であれば、再びアクセスしたとき自動でログインできる" do
    assert_equal @user, current_user
    assert logged_in?
  end
  
  test "ユーザのremember_tokenがremember_digestと合致しない場合、current_userはnilを返す" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
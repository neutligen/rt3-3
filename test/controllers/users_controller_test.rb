require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "ログインしていない場合はログインページにリダイレクトする" do
    get :index
    assert_redirected_to login_url
  end

  test "新規登録ページにアクセスできる" do
    get :new
    assert_response :success
  end
  
  test "ログインせずにedit画面に進んだ場合、エラーを表示してログイン画面に戻す。" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "ログインせずにupdateを実行したら、エラーを返してログイン画面に戻す。" do
    get :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "別のユーザーのエディットページに入ろうとするとエラーになる" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "別のユーザーの設定を変更したらエラーになる" do
    log_in_as(@other_user)
    get :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "ログインしていない場合は削除処理不可" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "管理者以外のユーザー削除処理不可" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end

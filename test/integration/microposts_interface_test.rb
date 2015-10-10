require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "マイクロポストのインターフェース" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    micropost = assigns(:micropost)
    assert micropost.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセスする
    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end
  
  test "投稿するとサイドバーの表示件数が増える" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count}件", response.body
    # マイクロポストのないユーザ
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0件", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1件", response.body
  end
end
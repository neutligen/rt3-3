require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "ユーザ検証" do
    assert @user.valid?
  end
  
  test "名前の存在性チェック" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "メールアドレスの存在性チェック" do
    @user.email = "  "
    assert_not @user.valid?
  end
  
  test "名前は50文字以内" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "メールアドレスは255文字以内" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "正しいメールアドレスの形式チェック" do
    valid_addresses = %w[user@example.com USRE@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?,"#{valid_address.inspect} は正しい形式です"
    end
  end
  
  test "不正なメールアドレスの形式チェック" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} は不正な形式です"
    end
  end
  
  test "メールアドレスに重複は無い" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "パスワードの存在性チェック" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end
  
  test "パスワードの最低文字数（６文字）チェック" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end
  
  test "別ブラウザでログアウトした場合（remember_digestがnil）、 remember_tokenでログインできない（authenticated?メソッドがfalseを返す）" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "投稿者が削除されたらその投稿者のマイクロポストも削除される。" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "フォローしたりフォローを外れたりでき、かつ確認できる" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "フィードすべきユーザの投稿を表示し、フイードすべきでないユーザの投稿は表示しない" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    # フォローしているユーザの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    
    # フォローしていないユーザの投稿は表示されない
    archer.microposts.each do |post_unfollow|
      assert_not michael.feed.include?(post_unfollow)
    end
  end
  
end

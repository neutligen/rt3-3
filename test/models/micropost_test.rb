require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "マイクロポストのバリデーション確認" do
    assert @micropost.valid?
  end

  test "ユーザIDが存在し無い場合は投稿できない" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "内容のない投稿は不可" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "投稿文字数の上限は140文字" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "投稿は新しいものから順に表示する" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
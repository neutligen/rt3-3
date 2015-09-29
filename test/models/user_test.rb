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
end

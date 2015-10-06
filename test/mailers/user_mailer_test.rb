require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "アカウントの有効化" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "メールアドレスの確認", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["neutligen@gmail.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end

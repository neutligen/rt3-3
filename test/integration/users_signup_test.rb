require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
 
 test "無効な内容の登録はエラーになる" do
   get signup_path
   assert_no_difference 'User.count' do
     post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
   end
   assert_template 'users/new'
 end
 
 test "有効な内容は登録できる" do
   assert_difference 'User.count', 1 do
     post_via_redirect users_path, user: { name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar" }
   end
   assert_template 'users/show'
 end
 
end

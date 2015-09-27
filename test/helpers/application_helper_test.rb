require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full_titleヘルパーの誤字チェック" do
    assert_equal full_title, "Ruby on Rails Tutorial Test App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Test App"
  end
end

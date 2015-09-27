require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  def setup
    @base_title = "Ruby on Rails Tutorial Test App"
  end
  
  test "homeページにアクセスできる" do
    get :home
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "helpページにアクセスできる" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end
  
  test "aboutページにアクセスできる" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
  test "contactページにアクセスできる" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end
  
  test "バリデーションチェック" do
    assert @relationship.valid?
  end
  
  test "follower_idがあるか" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end
  
  test "followed_idがあるか" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
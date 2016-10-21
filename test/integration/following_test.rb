require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @person  = users(:michael)
    @other = users(:archer)
    log_in_as(@person)
  end

  test "following page" do
    get following_user_path(@person)
    assert_not @person.following.empty?
    assert_match @person.following.count.to_s, response.body
    @person.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@person)
    assert_not @person.followers.empty?
    assert_match @person.followers.count.to_s, response.body
    @person.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "should follow a user the standard way" do
    assert_difference '@person.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end
  
  test "should follow a user with Ajax" do
    assert_difference '@person.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end
  
  test "should unfollow a user the standard way" do
    @person.follow(@other)
    relationship = @person.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@person.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
  
  test "should unfollow a user with Ajax" do
    @person.follow(@other)
    relationship = @person.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@person.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end

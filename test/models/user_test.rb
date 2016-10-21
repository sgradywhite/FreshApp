require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @person = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @person.valid?
  end

  test "name should be present" do
    @person.name = "     "
    assert_not @person.valid?
  end

  test "email should be present" do
    @person.email = "     "
    assert_not @person.valid?
  end

  test "name should not be too long" do
    @person.name = "a" * 51
    assert_not @person.valid?
  end

  test "email should not be too long" do
    @person.email = "a" * 244 + "@example.com"
    assert_not @person.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @person.email = valid_address
      assert @person.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @person.email = invalid_address
      assert_not @person.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @person.dup
    duplicate_user.email = @person.email.upcase
    @person.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @person.password = @person.password_confirmation = " " * 6
    assert_not @person.valid?
  end

  test "password should have a minimum length" do
    @person.password = @person.password_confirmation = "a" * 5
    assert_not @person.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @person.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do 
    @person.save
    @person.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @person.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end

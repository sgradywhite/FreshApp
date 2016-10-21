require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @person = users(:michael)
    remember(@person)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @person, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @person.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @person = users(:michael)
  end
  
  test "profile display" do
    get user_path(@person)
    assert_template 'users/show'
    assert_select 'title', full_title(@person.name)
    assert_select 'h1', text: @person.name
    assert_select 'h1>img.gravatar'
    assert_match @person.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @person.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end

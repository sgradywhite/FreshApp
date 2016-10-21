require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @person = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@person)
    get edit_user_path(@person)
    assert_template 'users/edit'
    patch user_path(@person), user: { name: "",
                                    email: "user@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@person)
    log_in_as(@person)
    assert_redirected_to edit_user_path(@person)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@person), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @person
    @person.reload
    assert_equal name,  @person.name
    assert_equal email, @person.email
  end
end

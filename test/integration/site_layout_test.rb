require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path

    get signup_path
    assert_select "title", full_title("Sign up")

    get login_path
    assert_select "a[href=?]", signup_path

    log_in_as(@user)
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    get edit_user_path(@user)
    assert_select "a[href=?]", "http://gravatar.com/emails", text: "change"

    log_in_as(@other_user)
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    get edit_user_path(@user)
    assert_redirected_to root_path
  end
end

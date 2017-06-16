require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bryan)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email:"",password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: {session:{email:@user.email,password:'password'}}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: {session:{email:@user.email,password:'password'}}
    assert !session[:user_id].nil?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not !session[:user_id].nil?
    assert_redirected_to root_url
    # Simulate a user clicking Logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count:0
  end

  test "login with remembering" do
    post login_path, params:{session: {email:@user.email,password:'password',remember_me: '1'}}
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # log in to set the cookie.
    post login_path, params:{session: {email:@user.email,password:'password',remember_me: '1'}}
    # login again and verify that the cookie is deleted.
    post login_path, params:{session: {email:@user.email,password:'password',remember_me: '0'}}
    assert_empty cookies['remember_token']
  end

end

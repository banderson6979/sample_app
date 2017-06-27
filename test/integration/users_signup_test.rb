require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:bryan)
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    # assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user:{name:"Example User", email:"user@example.com",password:"password",password_confirmation:"password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    post login_path, params:{session: {email:@user.email,password:'password',remember_me: '1'}}
    assert_not !session[:user_id]
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not !session[:user_id]
    # valid token, invalid email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not !session[:user_id]
    # valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert !session[:user_id].nil?
  end

end

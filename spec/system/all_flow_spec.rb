require 'rails_helper'

describe "all flow", type: :system do
  before :each do
    @user = User.create(username: 'test', email: 'test@gmail.com', password: '11111111')
  end

  it "all flow" do
    signs_me_in
    edit_profile
    edit_password_with_wrong_value
    edit_password_with_valid_value
    logout
    signs_me_in_with_new_pw
  end

  def signs_me_in
    visit '/login'
    fill_in 'email', with: @user.email
    fill_in 'password', with: '11111111'
    click_button 'login'
    expect(page).to have_content 'login succeed'
  end

  def edit_profile
    click_link 'Edit'
    fill_in 'user_username', with: 'iamgroot'
    click_button 'Update User'
    expect(page).to have_content 'iamgroot'
  end

  def edit_password_with_wrong_value
    click_link 'Edit'
    fill_in 'user_password', with: '33333333'
    fill_in 'user_password_confirmation', with: '22222222'
    click_button 'Update User'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  def edit_password_with_valid_value
    fill_in 'user_password', with: '22222222'
    fill_in 'user_password_confirmation', with: '22222222'
    click_button 'Update User'
    expect(page).to have_content "user updated"
  end

  def logout
    click_link 'Logout'
    expect(page).to have_content "Login Page"
  end

  def signs_me_in_with_new_pw
    visit '/login'
    fill_in 'email', with: @user.email
    fill_in 'password', with: '22222222'
    click_button 'login'
    expect(page).to have_content 'login succeed'
  end

end

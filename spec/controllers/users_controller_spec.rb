require 'rails_helper'
RSpec.shared_examples :required_logged_in do
  it "redirects to login page if not logged in" do
    action
    expect(response).to redirect_to login_path
  end
end

RSpec.shared_examples :required_same_user do
  it "redirects to profile page if logged in but not the same user" do
    action
    expect(response).to redirect_to user_path(user2.id)
  end
end

RSpec.describe UsersController, type: :controller do
  before do
    @user = User.create(email: 'test@gmail.com', password: '12345678')
    @user2 = User.create(email: 'test2@gmail.com', password: '12345678')
  end

  describe '#show' do
    it_behaves_like :required_logged_in do
      let(:action) {
        get :show, params: { id: @user.id }
      }
    end
    it_behaves_like :required_same_user do
      let(:action) {
        get :show, params: { id: @user.id }, session: { user_id: @user2.id }
      }
      let(:user2) { @user2 }
    end

    context 'logged in' do
      it "redirects to login page" do
        get :show, params: { id: @user.id }, session: { user_id: @user.id }
        expect(response).to render_template :show
      end
    end
  end

  describe '#create' do
    context 'with right user params' do
      before do
        @user_email = 'test4@gmail.com'
        params = { user: { email: @user_email, password: '12345678', password_confirmation: '12345678' } }
        post :create, params: params
      end

      it 'sends a email to user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq [@user_email]
      end
      it 'redirects to login page' do
        expect(response).to redirect_to login_path
      end
    end
    
    context 'with invalid params' do
      before do
        params = { user: { email: 'test@gmail.com', password: '92345678', password_confirmation: '12345678' } }
        post :create, params: params
      end

      it 'shows error message' do
        expect(controller.flash[:alert]).to include "Password confirmation doesn't match Password"
      end
      it 'renders :new' do
        expect(response).to render_template :new
      end
    end
  end

  describe '#edit' do
    it_behaves_like :required_logged_in do
      let(:action) {
        get :edit, params: { id: @user.id }
      }
    end
    it_behaves_like :required_same_user do
      let(:action) {
        get :edit, params: { id: @user.id }, session: { user_id: @user2.id }
      }
      let(:user2) { @user2 }
    end
  end

  describe '#update' do
    it_behaves_like :required_logged_in do
      let(:action) {
        params = { id: @user.id, user: { username: @user.username, password: '11111111', password_confirmation: '11111111' } }
        patch :update, params: params
      }
    end
    it_behaves_like :required_same_user do
      let(:action) {
        params = { id: @user.id, user: { username: @user.username, password: '11111111', password_confirmation: '11111111' } }
        patch :update, params: params, session: { user_id: @user2.id }
      }
      let(:user2) { @user2 }
    end

    context 'wtih right params' do
      before do
        params = { id: @user.id, user: { username: @user.username, password: '11111111', password_confirmation: '11111111' } }
        patch :update, params: params, session: { user_id: @user.id }
      end

      it 'updates user data' do
        expect(User.find(@user.id).bcrypt_password == '11111111').to be true
      end
      it 'redirect to user profile' do
        expect(response).to redirect_to user_path(@user)
      end
    end

    context 'wtih username but with empty pw and pw confirmation' do
      before do
        params = { id: @user.id, user: { username: 'hahoh', password: '', password_confirmation: '' } }
        patch :update, params: params, session: { user_id: @user.id }
      end
      
      it 'updates username' do
        expect(User.find(@user.id).username).to eq 'hahoh'
      end
    end

    context 'with wrong params' do
      before do
        params = { id: @user.id, user: { username: @user.username, password: '11111111', password_confirmation: '11111112' } }
        patch :update, params: params, session: { user_id: @user.id }
      end

      it 'shows error message' do
        expect(controller.flash[:alert]).to include "Password confirmation doesn't match Password"
      end
      it 'renders :edit' do
        expect(response).to render_template :edit
      end
    end
  end
end


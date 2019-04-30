require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @user = User.create(email: 'test@gmail.com', password: '12345678')
  end

  describe '#new' do
    it 'redirects to user profile page if user logged in' do
      get :new, session: { user_id: @user.id }
      expect(response).to redirect_to user_path(@user)
    end
  end

  describe '#create' do
    context 'with valid email, but invalid password' do
      it 'renders :new' do
        post :create, params: { email: @user.email, password: 'xxx' }
        expect(response).to render_template :new
      end
    end
    context 'with valid email, and right password' do
      before { post :create, params: { email: @user.email, password: '12345678' } }

      it 'redirects to user profile' do
        expect(response).to redirect_to user_path(@user)
      end
      it 'sets user_id in session' do
        expect(controller.session[:user_id]).to be @user.id
      end
    end
    context 'with invalid email' do
      it 'renders :new' do
        post :create, params: { email: 'xxxx', password: 'xxx' }
        expect(response).to render_template :new
      end
    end
  end

  describe '#destroy' do
    before { delete :destroy, params: { id: @user.id } }
    it 'cleans user_id in session' do
      expect(controller.session[:user_id]).to be nil
    end
    it 'redirects to login page' do
      expect(response).to redirect_to login_path
    end
  end
end

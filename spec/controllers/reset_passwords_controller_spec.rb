require 'rails_helper'

RSpec.describe ResetPasswordsController, type: :controller do
  before :each do
    @user = User.create(email: 'test@gmail.com', password: '12345678')
  end

  describe '#create' do
    context 'email is existed and with right pw and pw confirmation' do
      before do
        post :create, params: { email: @user.email }
      end

      it 'sends a email to email of user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq [@user.email]
      end
      it 'sends a email with reset pw url' do
        @user.reload
        expect(ActionMailer::Base.deliveries.last.body.raw_source).to include @user.reset_digest
      end
      it 'render :new' do
        expect(response).to render_template :new
      end
    end

    context 'email is not existed' do
      before do
        post :create, params: { email: 'no@gmail.com' }
      end

      it 'does not send email' do
        expect(ResetPasswordMailer).to_not receive(:reset_password_link) 
      end
      it 'render :new' do
        expect(response).to render_template :new
      end
    end
  end

  describe '#edit' do
    it 'renders :edit template if it is valid reset_digest' do
      @user.set_reset_password_variables
      reset_digest = @user.reset_digest

      get :edit, params: { id: reset_digest }

      expect(response).to render_template :edit
    end
    it 'redirects to login path if system can not find the user by reset_digest' do

      get :edit, params: { id: 'dsfdsf' }

      expect(response).to redirect_to login_path
    end
  end

  describe '#do_password_reset' do
    context 'with invalid reset digest' do
      it 'redirects to login page' do
        post :do_password_reset, params: { id: 'xxxx' }
        expect(response).to redirect_to login_path
      end
    end

    context 'with valid reset digest but pw is empty' do
      it 'renders edit page if reset digest if valid but password is empty' do
        @user.set_reset_password_variables
        reset_digest = @user.reset_digest

        post :do_password_reset, params: { id: reset_digest, password: '', password_confirmation: '12345678' }

        expect(response).to render_template :edit
      end
    end

    context 'with valid reset digest, pw and pw confirmation' do
      before do
        @user.set_reset_password_variables
        reset_digest = @user.reset_digest
        @new_pw = '23456789' 

        post :do_password_reset, params: { id: reset_digest, password: @new_pw, password_confirmation: @new_pw }
      end

      it 'updates password' do
        expect(User.last.bcrypt_password == @new_pw).to be true
      end
      it 'redirects to login page' do
        expect(response).to redirect_to login_path
      end
    end

    context 'with valid reset digest, but invalid pw' do
      before do
        @user.set_reset_password_variables
        reset_digest = @user.reset_digest

        post :do_password_reset, params: { id: reset_digest, password: '23456789', password_confirmation: '12345678' }
      end

      it 'shows error message' do
        expect(controller.flash[:alert]).to include "Password confirmation doesn't match Password"
      end
      it 'renders template :edit' do
        expect(response).to render_template :edit
      end
    end
  end
end

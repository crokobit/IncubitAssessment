require 'rails_helper'

RSpec.describe User, type: :model do
  describe "on creating" do
    it 'set prefix as username' do
      User.create(email: 'fortest@gmail.com', password: '12345678')
      expect(User.last.username).to eq 'fortest'
    end
    it 'username can be smaller than 5 chars' do
      User.create(email: 'test@gmail.com', password: '12345678')
      expect(User.last.username).to eq 'test'
    end
    it 'password lenght can not be smaller than 8 chars' do
      user = User.create(email: 'test@gmail.com', password: '1')
      expect(user.errors.first).to eq [:password, "length must greater than 8"]
    end
  end

  describe "on updating" do
    it 'has error if you update username with string smaller that 5 chars' do
      user = User.create(email: 'test@gmail.com', password: '12345678')
      user.update(username: 'dddd' ,password: 'j')

      expect(user.errors[:username]).to eq ["username length must at least five chars"]
    end
    it 'updates the password with username string length at least 5 chars' do
      user = User.create(email: 'test@gmail.com', password: '12345678')
      user.update(username: 'ddddd')

      expect(User.last.username).to eq 'ddddd'
    end
    it 'pass validation with username < 5 chars, username not changed but password changed' do
      user = User.create(email: 'test@gmail.com', password: '12345678')
      user.update(password: '23456789')

      expect(User.last.bcrypt_password == '23456789').to be true
    end
  end

  describe "reset password variables" do
    context "#set_reset_password_variables" do
      it 'set reset_digest' do
        user = User.create(email: 'test@gmail.com', password: '12345678')
        expect(user.reset_digest).to be nil
        user.set_reset_password_variables
        expect(User.last.reset_digest).to_not be nil
      end
    end
    context "#has_valid_reset_digest?" do
      it 'returns false if it is generated 6 hours before' do
        user = User.create(email: 'test@gmail.com', password: '12345678')
        user.reset_sent_at = DateTime.now.ago(7.hours)
        user.save

        expect(User.last.has_valid_reset_digest?).to be false
      end
      it 'returns true if it is generated within 6 hours' do
        user = User.create(email: 'test@gmail.com', password: '12345678')
        user.reset_sent_at = DateTime.now.ago(5.hours)
        user.save

        expect(User.last.has_valid_reset_digest?).to be true
      end
    end
    context "#clear_reset_password_variables" do
      it 'clears reset_digest and reset_sent_at' do
        user = User.create(email: 'test@gmail.com', password: '12345678')
        user.set_reset_password_variables
        user.clear_reset_password_variables

        expect(User.last.reset_digest).to be nil
        expect(User.last.reset_sent_at).to be nil
      end
    end
  end
end

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
    it 'username can not smaller that 5 chars' do
      user = User.create(email: 'test@gmail.com', password: '12345678')
      user.update(username: 'dddd' ,password: 'j')
      expect(User.last.username).to eq 'test'
    end
    it 'pass validation with username < 5 chars, username not changed but password changed' do
      user = User.create(email: 'test@gmail.com', password: '12345678')
      user.update(password: '23456789')
      expect(User.last.bcrypt_password == '23456789').to be true
    end
  end
end

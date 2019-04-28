require 'rails_helper'

RSpec.describe User, type: :model do
  describe "on creating" do
    it 'set prefix as username' do
      User.create(email: 'fortest@gmail.com', password: 'j')
      expect(User.last.username).to eq 'fortest'
    end
    it 'username can be smaller that 5 chars' do
      User.create(email: 'test@gmail.com', password: 'j')
      expect(User.last.username).to eq 'test'
    end
  end

  describe "on updating" do
    it 'username can not smaller that 5 chars' do
      user = User.create(email: 'test@gmail.com', password: 'j')
      user.update(username: 'dddd' ,password: 'j')
      expect(User.last.username).to eq 'test'
    end
    it 'pass validation with username < 5 chars, username not changed but password changed' do
      user = User.create(email: 'test@gmail.com', password: 'j')
      user.update(password: 'k')
      expect(User.last.password == 'k').to be true
    end
  end
end

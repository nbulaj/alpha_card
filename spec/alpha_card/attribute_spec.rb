require 'spec_helper'

describe AlphaCard::Attribute do
  class User
    include AlphaCard::Attribute

    attribute :name
    attribute :activated, values: [true, false]
    attribute :role, default: 'user', writable: false
  end

  class Moderator < User
    attribute :id, default: 11
    attribute :status, default: 'global', writable: false
    attribute :role, default: 'moderator', writable: false
  end

  class Admin < Moderator
    attribute :role, default: 'admin'
    remove_attribute :status
	attribute :birthday, format: /^\d{2}-\d{2}-\d{4}$/
  end

  context 'User' do
    it 'must set attributes from arguments on initialization' do
      user = User.new(name: 'John', activated: true)
      expect(user.name).to eq('John')
      expect(user.activated).to be_truthy
    end

    it 'must ignore non-writable attributes on initialization' do
      user = User.new(role: 'test')
      expect(user.role).to eq('user')
    end

    it 'must set default values' do
      expect(User.new.role).to eq('user')
    end

    it 'must not create writers for non-writable attributes' do
      expect { User.new.role = '111' }.to raise_error(NoMethodError)
    end

    it 'must raise an error on wrong values' do
      expect { User.new(activated: 'wrong') }.to raise_error(AlphaCard::InvalidAttributeValue)
    end
  end

  context 'Moderator' do
    it 'must inherit attributes' do
      moderator = Moderator.new(name: 'John', activated: true)
      expect(moderator.attributes).to eq(name: 'John', activated: true, id: 11, role: 'moderator', status: 'global')
    end

    it 'must override attributes default values' do
      expect(Moderator.new.role).to eq('moderator')
    end
  end

  context 'Admin' do
    it 'must inherit superclass attributes' do
      admin = Admin.new(name: 'John', activated: true)
      expect(admin.name).to eq('John')
      expect(admin.id).to eq(11)
      expect(admin.activated).to be_truthy
    end

    it 'must override superclass attributes default values' do
      expect(Admin.new.role).to eq('admin')
    end

    it 'must override superclass attributes options' do
      admin = Admin.new
      admin.role = 'something_new'
      expect(admin.role).to eq('something_new')
    end

    it 'must remove attributes' do
      expect { Admin.new.status = 'local' }.to raise_error(NoMethodError)
    end
	
	it 'must validate attribute format' do
      expect { Admin.new.birthday = 'local' }.to raise_error(AlphaCard::InvalidAttributeFormat)
    end
  end
end

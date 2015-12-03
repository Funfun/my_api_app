require 'rails_helper'

RSpec.describe User, :type => :model do
  describe '.authenticate' do
    it 'returns false if passed login does not match with non of users' do
      expect(User).to receive(:find_by).with(login: 'bob'){ nil }
      expect(described_class.authenticate('bob', 'secret')).to be_nil
    end

    let(:user){ instance_double(User) }
    it 'returns true for correct login and password' do
      expect(User).to receive(:find_by).with(login: 'bob'){ user }
      expect(user).to receive(:authenticate).with('secret'){ true }
      expect(described_class.authenticate('bob', 'secret')).to eq(user)
    end
  end
end

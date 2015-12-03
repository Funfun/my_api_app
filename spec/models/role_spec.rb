require 'rails_helper'

RSpec.describe Role, :type => :model do
  specify {
    expect(Role::ADMIN).to eq(0)
    expect(Role::USER).to eq(1)
    expect(Role::GUEST).to eq(2)
  }
end

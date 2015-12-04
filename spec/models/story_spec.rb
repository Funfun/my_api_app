require 'rails_helper'

RSpec.describe Story, :type => :model do
  describe 'initial status' do
    subject{ Story.create(body: 'example') }
    it 'assigs pending status as default' do
      is_expected.to have_status(:pending)
    end
  end
end

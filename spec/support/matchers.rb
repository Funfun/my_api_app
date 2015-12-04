require 'rspec/expectations'

RSpec::Matchers.define :have_status do |expected|
  match do |actual|
    actual.status == described_class::STATUS.const_get(expected.to_s.upcase.to_sym)
  end
end

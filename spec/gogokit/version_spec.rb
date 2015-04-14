require 'spec_helper'

describe '::VERSION' do
  it 'should have a value' do
    expect(GogoKit::VERSION).not_to be_nil
  end
end

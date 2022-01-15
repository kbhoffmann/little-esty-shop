require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:threshold) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
end 

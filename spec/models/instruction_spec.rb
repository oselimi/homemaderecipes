require 'rails_helper'

RSpec.describe Instruction, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:instruction) { create(:instruction, user: user, recipe: recipe) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:recipe) }
  end

  describe 'validations' do
    it { should validate_presence_of(:step) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:step).is_at_least(Instruction::MIN_LENGTH_OF_STEP) }
    it { should validate_length_of(:body).is_at_least(Instruction::MIN_LENGTH_OF_BODY) }
  end
end

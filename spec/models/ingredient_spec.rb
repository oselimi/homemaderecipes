require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:ingredient) { create(:ingredient, recipe: recipe, user: user) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:recipe) }
  end
  
  describe "valdidates" do
    it { should validate_presence_of(:amount) }
    it { should validate_length_of(:amount).is_at_most(Ingredient::MAX_LENGTH_OF_AMOUNT) }
  end
end

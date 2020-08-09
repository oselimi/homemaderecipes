require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }

  before { recipe }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:instructions).dependent(:destroy) }
    it { should have_many(:ingredients).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:title).is_at_most(Recipe::MAX_LENGTH_OF_TITLE) }
    it { should validate_length_of(:description).is_at_most(Recipe::MAX_LENGTH_OF_DESCRITPION) }
  end
end

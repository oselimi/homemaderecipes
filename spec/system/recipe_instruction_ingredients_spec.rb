require 'rails_helper'

RSpec.describe 'RecipeInstructionIngredients' do
  before do
    driven_by(:rack_test)
  end
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:instruction) { create(:instruction, recipe: recipe, user: user) }
  let(:ingredient) { create(:ingredient, recipe: recipe, user: user) }

  describe 'add new recipe including instructions and ingredients' do
    before do
      login_system_as(user)
      visit '/recipes/new'
    end

    it 'create new recipe' do
      fill_in 'Add Title of Recipe', with: 'New title'
      fill_in 'Add Description of Recipe', with: 'New description'

      recipe.instructions.each do
        fill_in 'Add Title of Instruction', with: 'New step'
        fill_in 'Add Body of Instruction', with: 'New body'
      end

      recipe.ingredients.each do
        fill_in 'Add Ingredients', with: 'New ingredients'
      end

      click_on 'Save Recipe'

      visit "/recipes/#{recipe.id}"
    end
  end

  describe 'edit recipe path' do
    let(:edit_title) { 'edit title of recipe' }
    let(:edit_description) { 'edit description of recipe' }

    before do
      login_system_as(user)
      visit "/recipes/#{recipe.id}/edit"

      fill_in 'Add Title of Recipe', with: edit_title
      fill_in 'Add Description of Recipe', with: edit_description

      recipe.instructions.each do |recipe|
        recipe.step
        recipe.body
      end

      click_on 'Update Recipe'
    end

    specify { expect(recipe.reload.title).to eq edit_title }
    specify { expect(recipe.reload.description).to eq edit_description }
  end

  describe 'submitting to the show action' do
    before do
      login_system_as(user)
      visit "/recipes/#{recipe.id}"
    end

    context 'delete action' do
      it 'deleted recipe with ingredients and instructions' do
        click_on 'Delete'
        expect(page).to have_content('Recipe deleted!')
      end
    end

    context 'destroy only instructions and ingredients' do
      it 'remove instructions and ingredients' do
        click_on 'Edit'

        fill_in 'Add Title of Recipe', with: recipe.title
        fill_in 'Add Description of Recipe', with: recipe.description

        recipe.instructions.each do |recipe|
          recipe.step
          recipe.body
          recipe.check('remove')
        end

        recipe.ingredients.each do |recipe|
          recipe.amount
          recipe.check('remove')
        end

        click_on 'Update Recipe'
        expect(page).to have_content(recipe.title)
        expect(page).to have_content(recipe.description)
      end
    end
  end
end

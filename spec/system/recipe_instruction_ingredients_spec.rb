require 'rails_helper'

RSpec.describe "RecipeInstructionIngredients", type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:instruction) { create(:instruction, recipe: recipe, user: user) }
  let(:ingredient) { create(:ingredient, recipe: recipe, user: user) }

  describe "Add new recipe including instructions and ingredients" do
    before do
      login_system_as(user)
      visit "/recipes/#{recipe.id}"
    end

    it "should be valid" do

      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.description)
      expect(page).to have_link('Add more instructions')
      expect(page).to have_link('Add more ingredients')

      recipe.instructions.each do |recipe|
        recipe.step
        recipe.body
      end
      recipe.ingredients.each do |recipe|
        recipe.amount
      end

      expect(page).to have_link("Back")
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end

    describe "edit recipe path" do
      before do
        login_system_as(user)
        visit "/recipes/#{recipe.id}/edit"
      end

      it "editing all attributes" do

        fill_in "Add Title of Recipe", with: "Edit title recipe"
        fill_in "Add Description of Recipe", with: "Edit description"

        recipe.instructions.each do |recipe|
          recipe.step("Edit first step")
          recipe.body("Edit body of instructions recipe")
        end
        recipe.ingredients.each do |recipe|
          recipe.amount("Edit ingredients")
        end

        click_on "Update Recipe"

        visit "/recipes/#{recipe.id}"
      end
    end
  end

  describe "delete an recipe" do
    before do
      login_system_as(user)
      visit "/recipes/#{recipe.id}"
    end

    it "remove instructions and ingredients" do
      click_on "Edit"

      title = "Edit title recipe"
      description = "Edit description"

      within('form') do
        fill_in "Add Title of Recipe", with: recipe.title
        fill_in "Add Description of Recipe", with: recipe.description
      end

      recipe.instructions.each do |recipe|
        recipe.step
        recipe.body
        recipe.check("remove")
      end
      recipe.ingredients.each do |recipe|
        recipe.amount
        recipe.check("remove")
      end

      click_on "Update Recipe"

      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.description)
    end

    it "deleted recipe with ingredients and instructions" do
      
      click_on "Delete"
  
      expect(page).to have_content("Recipe deleted!")
    end
  end
end

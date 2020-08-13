require 'rails_helper'

RSpec.describe "Recipes", type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let!(:recipe) { create(:recipe, title: "First title", description: "description of recipe",
                          user: user) }
  let!(:other_recipe) { create(:recipe, title: "Second title", description: "description of secont recipe",
                        user: other) }

  describe "when not logged in" do
    before { visit '/' }

    it "should have links in navbar" do
      expect(page).to have_link("Login")
      expect(page).to have_link("Signup")
    end

    it "shows all recipes without logged in" do
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.description)
      expect(page).to have_link(recipe.user.username)
      expect(page).to have_link("Show")
      expect(page).to have_content(other_recipe.title)
      expect(page).to have_content(other_recipe.description)
      expect(page).to have_link(other_recipe.user.username)
      expect(page).to have_link("Show")
    end
  end

  describe "when user logged in" do
    before do
      login_system_as(user)
      visit '/'
    end

    it "should have links in navbar after logged in" do
      expect(page).to have_selector("i", class: "fa fa-plus btn")
      expect(page).to have_selector("i", class: "fa fa-times-circle btn")
    end

    it "display of recipes path when current user" do
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.description)
      expect(page).to have_link(recipe.user.username)
      expect(page).to have_link("Show")
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end

    it "is display of recipes when user not current user" do
      expect(page).to have_content(other_recipe.title)
      expect(page).to have_content(other_recipe.description)
      expect(page).to have_link(other_recipe.user.username)
      expect(page).to have_link("Show")
    end
  end
end

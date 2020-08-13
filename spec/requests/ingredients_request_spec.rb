require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:ingredient) { create(:ingredient, user: user, recipe: recipe) }

  describe "GET /new" do
    before do
      login_as(user)
      get "/recipes/#{recipe.id}/ingredients/new"
    end

    it "create a ingredient and returns http success" do
      expect(response).to have_http_status(:success)

      post_params = {
        params: {
          ingredient: {
            amount: "125 ml  milk"
          }
        }
      }

      post "/recipes/#{recipe.id}/ingredients", post_params

    end

    it "should have empty attributes" do
      post_params = {
        params: {
          ingredient: {
            amount: ""
          }
        }
      }

      post "/recipes/#{recipe.id}/ingredients", post_params
      expect(response).to render_template(:new)
    end
  end

  describe "GET /edit" do
    before do
      login_as(user)
      get "/recipes/#{recipe.id}/ingredients/#{ingredient.id}/edit" 
    end

    it "should be correct editing" do
      expect(response).to have_http_status(:ok)

      amount = "500ml watter"

      patch_params = { 
        params: {
          ingredient: {
            amount: ingredient.amount
          }
        }
      }

      patch "/recipes/#{recipe.id}/ingredients/#{ingredient.id}", patch_params
      expect(response).to redirect_to(recipe_ingredient_path(recipe, ingredient))
      expect(response).to have_http_status(:found)

      follow_redirect!

      expect(response.body).to include(ingredient.amount)
    end
  end

  describe "GET /destroy" do
    before do
      login_as(user)
      delete "/recipes/#{recipe.id}/ingredients/#{ingredient.id}" 
    end

    it "should be removed" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end
  end
end

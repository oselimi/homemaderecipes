require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }

  describe "GET /new" do
    before { get "/recipes/new" }

    it "create an recipes" do
      expect(response).to have_http_status(:success)
      
      title = "First title"
      description = "Description of recipes"

      post_params = {
        params: {
          recipe: {
            title: recipe.title,
            description: recipe.description
          }
        }
      }

      post "/recipes", post_params

      expect(response).to redirect_to(recipes_path)

      follow_redirect!

      expect(response.body).to include(recipe.title)
      expect(response.body).to include(recipe.description)
    end

    it "should be empty attributes" do
      expect(response).to have_http_status(:success)

      post_params = {
        params: {
          recipe: {
            title: "",
            description: ""
          }
        }
      }

      post "/recipes", post_params

      expect(response).to render_template(:new)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    before { get "/recipes/#{recipe.id}/edit" }
    
    it "edit an recipes" do
      expect(response).to have_http_status(:success)
      
      title = "edit title"
      description = "edit description"

      patch_params = {
        params: {
          recipe: {
            title: recipe.title,
            description: recipe.description
          }
        }
      }

      patch "/recipes/#{recipe.id}", patch_params
      expect(response).to redirect_to(assigns(:recipe))
      expect(response).to have_http_status(:found)
      
      follow_redirect!

      expect(response.body).to include(recipe.title)
      expect(response.body).to include(recipe.description)
    end
  end

  describe "GET /destroy" do
    before { delete "/recipes/#{recipe.id}" }
    
    it "edit an recipes" do
      expect(response).to have_http_status(302)
      
      expect(response).to redirect_to(root_path)
    end
  end
end

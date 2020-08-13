require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:instruction) { create(:instruction, recipe: recipe, user: user) }
  let(:ingredient) { create(:ingredient, recipe: recipe, user: user) }
  let(:other_user) { create(:user) }

  describe "GET /new" do
    context "when user not logged in" do
      before do 
        get "/recipes/new"
      end

      it "should be logged in with other user" do
        post_params = {
          params: {
            recipe: {
              title: "New recipe",
              description: "Description of my favorite recipe",
              step: "First intruction",
              body: "Body of intructions",
              amount: "Ingredints"
            }
          }
        }

        post "/recipes", post_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq "Please log in"
      end
    end
  end

  describe "GET /edit" do
    context "when user not logged in" do
      before { get "/recipes/#{recipe.id}/edit" }

      it "should be incorrect edited and redirect to login path" do
        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"
        amount = "0.20kg suger"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq "Please log in"
      end
    end

    context "when logged in current user" do
      before do 
        login_as(user)
        get "/recipes/#{recipe.id}/edit"
      end

      it "should be edited(recipe)" do

        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"
        amount = "0.20kg suger"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(assigns(:recipe))
        expect(response).to have_http_status(:found)

        follow_redirect!

        expect(response.body).to include(recipe.title)
        expect(response.body).to include(recipe.description)
        expect(response.body).to include(instruction.step)
        expect(response.body).to include(instruction.body)
        expect(response.body).to include(ingredient.amount)
      end

      it "should be not edited(recipe)" do

        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"
        amount = "0.20kg suger"

        patch_params = {
          params: {
            recipe: {
              title: "",
              description: "",
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to render_template(:edit)

        expect(response.body).to include(instruction.step)
        expect(response.body).to include(instruction.body)
        expect(response.body).to include(ingredient.amount)
      end

      it "should be recipe edited but remove instruction" do

        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"
        amount = "0.20kg suger"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(assigns(:recipe))
        expect(response).to have_http_status(:found)

        follow_redirect!

        expect(response.body).to include(recipe.title)
        expect(response.body).to include(recipe.description)
        expect(response.body).to include(ingredient.amount)
      end

      it "should be recipe edited but remove ingredient" do

        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(assigns(:recipe))
        expect(response).to have_http_status(:found)

        follow_redirect!

        expect(response.body).to include(recipe.title)
        expect(response.body).to include(recipe.description)
        expect(response.body).to include(instruction.step)
        expect(response.body).to include(instruction.body)
      end
    end

    context "when user logged in but not current user" do
      before do
        login_as(other_user)
        get "/recipes/#{recipe.id}/edit"
      end

      it "should be incorrect edit" do

        title = "edit title"
        description = "edit description"
        step = "Edit step"
        body = "This is body be available"
        amount = "0.20kg suger"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq "You must be current user!"
      end 
    end
  end

  describe "PATCH /Update" do
    context "when user not logged in" do
      before { patch "/recipes/#{recipe.id}" }

      it "should be invalid and redirect to login path" do
        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq "Please log in"
      end
    end

    context "when user logged in but not current user" do
      before do
        login_as(other_user)
        patch "/recipes/#{recipe.id}"
      end

      it "should be te redirect to root path" do
        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              step: instruction.step,
              body: instruction.body,
              amount: ingredient.amount
            }
          }
        }

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq "You must be current user!"
      end
    end
  end

  describe "DELETE /Delete" do
    context "when user logged in and delete recipe" do
      before do
        login_as(user)
        delete "/recipes/#{recipe.id}"
      end

      it "should be deleted(recipe)" do
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq "Recipe deleted!"
      end
    end

    context "when user note logged in" do
      before do
        delete "/recipes/#{recipe.id}"
      end

      it "should be redirect to login path" do
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq "Please log in"
      end
    end

    context "when user logged in but incorrect user" do
      before do
        login_as(other_user)
        delete "/recipes/#{recipe.id}"
      end

      it "should be redirect to login path" do
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq "You must be current user!"
      end
    end
  end
end

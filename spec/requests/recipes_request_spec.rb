require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let(:instruction) { create(:instruction, recipe: recipe, user: user) }
  let(:ingredient) { create(:ingredient, recipe: recipe, user: user) }
  let(:other_user) { create(:user) }

  describe 'GET /new' do
    context 'when user non logged in' do
      before { get '/recipes/new' }

      it 'should not be create' do
        post_params = {
          params: {
            recipe: {
              title: 'add new title',
              description: 'add newasdsaddas',
              instructions_attributes: [
                step: 'First step',
                body: 'new body'
              ],
              ingredients_attributes: [
                amount: 'new amount'
              ]
            }
          }
        }
        post '/recipes', post_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please log in'
      end
    end

    context 'when user not logged in' do
      before do
        get '/recipes/new'
      end

      it 'should be logged in with other user' do
        post_params = {
          params: {
            recipe: {
              title: 'New recipe',
              description: 'Description of my favorite recipe',
              instructions_attributes: [
                step: 'First step',
                body: 'new body'
              ],
              ingredients_attributes: [
                amount: 'new amount'
              ]
            }
          }
        }

        post '/recipes', post_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please log in'
      end
    end
  end

  describe 'GET /edit' do
    context 'when user logged in' do
      before do
        login_as(user)
        get "/recipes/#{recipe.id}/edit"

        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: "edit descriptiomn"
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
      end
      specify { expect(response).to redirect_to(assigns(:recipe)) }
    end

    context 'when user not logged in' do
      before { get "/recipes/#{recipe.id}/edit" }
      it 'should be incorrect edited and redirect to login path' do
        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              instructions_attributes: [
                step: instruction.step,
                body: instruction.body
              ],
              ingredients_attributes: [amount: ingredient.amount]
            }
          }
        }
        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please log in'
      end
    end

    context 'when user logged in but not current user' do
      before do
        login_as(other_user)
        get "/recipes/#{recipe.id}/edit"
      end

      it 'should be incorrect edit' do
        patch_params = {
          params: {
            recipe: {
              title: 'edit title',
              description: 'edit description',
              instructions_attributes: [
                step: 'edit step',
                body: 'edit body'
              ],
              ingredients_attributes: [
                amount: 'edit'
              ]
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'You must be current user!'
      end
    end
  end

  describe 'PATCH /Update' do
    context 'when user not logged in' do
      before { patch "/recipes/#{recipe.id}" }

      it 'should be invalid and redirect to login path' do
        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              instructions_attributes: [
                step: instruction.step,
                body: instruction.body
              ],
              ingredients_attributes: [amount: ingredient.amount]
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please log in'
      end
    end

    context 'when user logged in but not current user' do
      before do
        login_as(other_user)
        patch "/recipes/#{recipe.id}"
      end

      it 'should be te redirect to root path' do
        patch_params = {
          params: {
            recipe: {
              title: recipe.title,
              description: recipe.description,
              instructions_attributes: [
                step: instruction.step,
                body: instruction.body
              ],
              ingredients_attributes: [amount: ingredient.amount]
            }
          }
        }

        patch "/recipes/#{recipe.id}", patch_params
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'You must be current user!'
      end
    end
  end

  describe 'DELETE /Delete' do
    context 'when user logged in and delete recipe' do
      before do
        login_as(user)
        delete "/recipes/#{recipe.id}"
      end

      it 'should be deleted(recipe)' do
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'Recipe deleted!'
      end
    end

    context 'when user note logged in' do
      before do
        delete "/recipes/#{recipe.id}"
      end

      it 'should be redirect to login path' do
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq 'Please log in'
      end
    end

    context 'when user logged in but incorrect user' do
      before do
        login_as(other_user)
        delete "/recipes/#{recipe.id}"
      end

      it 'should be redirect to login path' do
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'You must be current user!'
      end
    end
  end
end

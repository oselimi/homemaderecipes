require 'rails_helper'

RSpec.describe "Instructions", type: :request do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }
    let(:instruction) { create(:instruction, user: user, recipe: recipe) }

    describe "GET /new" do
        before { get "/recipes/#{recipe.id}/instructions/new" }

        it "should be valid" do
            expect(response).to have_http_status(:success)
        
            post_params = {
                params: {
                    instruction: {
                        step: "1 step",
                        body: "commented how to cooking this recipe"
                    }
                }
            }

            post "/recipes/#{recipe.id}/instructions", post_params
            expect(response).to redirect_to(root_path)
        end
    end

    it "should be empty attributes" do
        post_params = {
            params: {
                instruction: {
                    step: "",
                    body: ""
                }
            }
        }

        post "/recipes/#{recipe.id}/instructions", post_params
        expect(response).to render_template(:new)
    end

    describe "GET /edit" do
        before { get "/recipes/#{recipe.id}/instructions/#{instruction.id}/edit" }

        it "should be valid" do
            expect(response).to have_http_status(:success)

            step = "1 step update"
            body = "commented how to cooking this recipe update"
            
            patch_params = {
                params: {
                    instruction: {
                        step: instruction.step,
                        body: instruction.body
                    }
                }
            }

            patch "/recipes/#{recipe.id}/instructions/#{instruction.id}", patch_params
            expect(response).to redirect_to(recipe_instruction_path(recipe, instruction))
            expect(response).to have_http_status(:found)

            follow_redirect!

            expect(response.body).to include(instruction.step)
            expect(response.body).to include(instruction.body)
        end

        it "should be empty attributes" do
            expect(response).to have_http_status(:success)

            patch_params = {
                params: {
                    instruction: {
                        step: " ",
                        body: " "
                    }
                }
            }

            patch "/recipes/#{recipe.id}/instructions/#{instruction.id}", patch_params
            expect(response).to render_template(:edit)
        end
    end

    describe "GET /destroy" do
        before { delete "/recipes/#{recipe.id}/instructions/#{instruction.id}" }
        it "should be deleted instructions" do
            expect(response).to have_http_status(302)
            expect(response).to redirect_to(root_path)
        end
    end
end

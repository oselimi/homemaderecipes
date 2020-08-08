require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /signup" do
    before { get "/signup" }
    it "returns http success and create valid user" do
      expect(response).to have_http_status(:success)
      post_params = {
        params: {
          user: {
            first_name: "john",
            last_name: "allen",
            handle_name: "allen99",
            email: "a@john.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }

      post "/users", post_params
      expect(response).to redirect_to(assigns(:user))
      follow_redirect!
      expect(response.body).to include("john allen")
      expect(response.body).to include("@allen99")
    end
  end

  it "empty attributes" do
    post_params = {
      params: {
        user: {
          first_name: "",
          last_name: "",
          handle_name: "",
          email: "",
          password: "",
          password_confirmation: ""
        }
      }
    }

    post "/users", post_params
    expect(response).to render_template(:new)
    expect(response).to have_http_status(200)
  end
end

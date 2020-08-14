require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'GET /login' do
    before { get '/login' }

    it 'should be successfully login' do
      expect(response).to have_http_status(:success)
      post_params = {
        params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
      }

      post '/login', post_params
      expect(response).to redirect_to(user_path(user))
    end

    it 'should be invalid login' do
      expect(response).to have_http_status(:success)
      post_params = {
        params: {
          session: {
            email: '',
            password: ''
          }
        }
      }

      post '/login', post_params
      expect(response).to render_template(:new)
      expect(flash[:danger]).to eq 'Invalid email/password'
    end
  end
end

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
    visit '/'
  end

  describe 'create new user' do
    it 'enables me to create user' do
      click_on 'Signup'

      fill_in 'First Name', with: 'Example'
      fill_in 'Last Name', with: 'User'
      fill_in 'Handle Name', with: 'user1'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'

      click_on 'Sign Up'

      expect(page).to have_content('Example User')
      expect(page).to have_content('@user1')
      expect(page).to have_content('user@example.com')
    end

    it 'have empty attributes' do
      click_on 'Signup'

      fill_in 'First Name', with: ''
      fill_in 'Last Name', with: ''
      fill_in 'Handle Name', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password Confirmation', with: ''

      click_on 'Sign Up'

      expect(page).to have_content('You have: 7 errors')
    end

    describe 'when user logged in' do
      let(:user) { create(:user) }
      it 'enable me to logged in' do
        click_on 'Login'

        within('form') do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password

          click_on 'Login'
        end

        expect(page).to have_content(user.full_name)
        expect(page).to have_content(user.username)
        expect(page).to have_content(user.email)

        user.recipes.each do |recipe|
          expect(page).to have_content(recipe)
          expect(page).to have_content(description)
          expect(page).to have_link('Show')
          expect(page).to have_link('Edit')
          expect(page).to have_link('Delete')
        end
      end

      it 'is any empty attribute show error' do
        click_on 'Login'

        within('form') do
          fill_in 'Email', with: ''
          fill_in 'Password', with: user.password

          click_on 'Login'
        end

        expect(page).to have_content('Invalid email/password')
      end
    end
  end

  describe 'show user profile' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }

    it 'enabel to show user profile' do
      visit "/users/#{user.id}"

      expect(page).to have_content(user.full_name)
      expect(page).to have_content(user.username)
      expect(page).to have_content(user.email)

      user.recipes.each do |recipe|
        expect(page).to have_content(recipe)
        expect(page).to have_content(description)
        expect(page).to have_link('Show')
      end
    end
  end
end

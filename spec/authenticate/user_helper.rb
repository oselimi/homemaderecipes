module UserHelper
  def login_as(user)
    post_params = {
        params: {
        session: {
        email: user.email,
        password: user.password
        }
      }
    }

    post login_path, post_params
  end

  def login_system_as(user)
    visit login_path

    within('form') do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password

        click_on 'Login'
      end
  end
end
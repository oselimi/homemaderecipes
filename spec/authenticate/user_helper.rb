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
end
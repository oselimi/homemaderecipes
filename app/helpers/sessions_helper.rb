module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    def logged_in?
        current_user.present?
    end

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end

    def current_user?(other_user)
        current_user == other_user
    end


    private

    def logged_in_user
        unless logged_in?
            flash[:danger] = "Please log in"
            redirect_to login_path
        end
    end
end

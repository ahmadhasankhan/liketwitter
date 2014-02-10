class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def login_user
    unless current_user
      flash[:notice]="Please Login First"
      redirect_to root_path
    end
  end

  def authorised_user
    if (current_user && !current_user.isadmin)
      flash[:notice]="Please Login First"
      redirect_to accessdenied_users_path
    end
  end

  if Rails.env.production?
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :render_404
      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActionController::UnknownController, with: :render_404
      rescue_from ActionController::UnknownAction, with: :render_404
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
    end
  end

  def render_404(exception)
    @not_found_path = exception.message
    respond_to do
      render template: 'page/error_404', status: 404
      render nothing: true, status: 404
    end
  end
  def un_authorised_user
    if (current_user)
      flash[:alert]="Please Logout First to register"
      redirect_to root_path
    end

  end
end
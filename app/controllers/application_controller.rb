class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  rescue ActionController::RoutingError
    render_not_found
  end

  private

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end

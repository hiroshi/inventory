# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include HttpError
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  protect_from_forgery # :secret => 'c23e808fd9c186e9a355fd6ff35899ae'
  filter_parameter_logging :password

  def index
    redirect_to computer_assets_path
  end

  def current_group
    current_user.group
  end
  helper_method :current_group
end

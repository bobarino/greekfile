class ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :check_subdomain
  private
  def after_confirmation_path_for(resource_name, resource)
    confirmation_sent_path
  end

  def confirmation_sent
  end
end

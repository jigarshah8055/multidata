class ApplicationController < ActionController::Base
  before_action :set_database

  helper_method :current_website

  # I use the entire domain, just change to find_by_subdomain and pass only the subdomain
  def current_website
    subdomain ||= request.subdomain
  end

  def set_database
    subdomain = current_website
    subdomain.present? ? Multidata::Application.use_database(subdomain) : Multidata::Application.revert_database
  end

  # Bonus - add view_path
  def set_paths
    self.prepend_view_path current_website.view_path unless current_website.view_path.blank?
  end
end

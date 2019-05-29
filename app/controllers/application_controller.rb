class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # #更新後はユーザープロフィール画面に戻る？
  # def user_root_path
  #   user_path
  # end

  protected

  def configure_permitted_parameters
    added_attrs = [ :user_name, :email, :password, :password_confirmation　]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end



end

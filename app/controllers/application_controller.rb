class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  after_action :flash_to_headers#←非同期表示後のフラッシュメッセージ

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_view_form_type

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


  private
  ##########↓非同期表示後のフラッシュメッセージ
  def flash_to_headers
    return unless request.xhr?

    response.headers['X-Flash-Messages'] = flash_json

    # ページをリロードした際に flash メッセージが残ってしまうのを防ぐ。
    flash.discard
  end

  def flash_json
    flash.inject({}) do |hash, (type, message)|
      # XSS 対策を施す。
      message = "#{ERB::Util.html_escape(message)}"
      # 日本語のメッセージをレスポンスヘッダに含めるために URL エンコードしておく。
      message = URI.escape(message)
      hash[type] = message
      hash
    end.to_json
  end
  ##########↑非同期表示後のフラッシュメッセージ

  def set_view_form_type
    #view_form_type→0：通常画面（サイドバーあり）、1：プレゼン用画面（サイドバーなし）
    @view_form_type = 0

    @form_name = ""
    @form_name_sub = ""

  end

end

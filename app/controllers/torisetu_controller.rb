class TorisetuController < ApplicationController

  before_action :set_torisetu_view_form_type

  def set_torisetu_view_form_type
    @form_name=t('long_msg.torisetu.rasikimono')
    #view_form_type→0：通常画面（サイドバーあり）、1：プレゼン用画面+取説画面（サイドバーなし）
    # @view_form_type = 1
  end

end

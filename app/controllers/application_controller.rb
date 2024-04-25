class ApplicationController < ActionController::Base
  private

  def validate_buffet_creation
    redirect_to '/buffets/new', notice: 'Você precisa cadastrar seu buffet ' \
      'antes de acessar outras páginas' if buffet_owner_signed_in? &&
      !current_buffet_owner.buffet
  end
end

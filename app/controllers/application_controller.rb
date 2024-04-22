class ApplicationController < ActionController::Base
  private

  def validate_buffet_creation
    redirect_to '/buffets/new', notice: 'Você precisa cadastrar seu buffet ' \
      'antes de acessar outras páginas' if current_buffet_owner.present? &&
      !current_buffet_owner.buffet.present?
  end
end

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf]) if params[:client]
  end

  private

  def validate_buffet_creation
    redirect_to '/buffets/new', notice: 'Você precisa cadastrar seu buffet ' \
      'antes de acessar outras páginas' if buffet_owner_signed_in? &&
      !current_buffet_owner.buffet
  end
end

class EventTypesController < ApplicationController
  before_action :validate_buffet_creation, only: [:show, :new, :create]
  before_action :authenticate_buffet_owner!, only: [:new, :create]

  def show
    @event_type = EventType.find params[:id]
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new event_type_params
    @event_type.buffet_id = current_buffet_owner.buffet.id

    return redirect_to current_buffet_owner.buffet, notice: 'Tipo de Evento ' \
      'cadastrado com sucesso!' if @event_type.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'adicionar o tipo de evento.'

    render :new
  end

  def event_type_params
    params.require(:event_type).permit :name,
                                       :description,
                                       :minimum_attendees,
                                       :maximum_attendees,
                                       :duration,
                                       :menu,
                                       :provides_alcohol_drinks,
                                       :provides_decoration,
                                       :provides_parking_service,
                                       :serves_external_address
  end
end
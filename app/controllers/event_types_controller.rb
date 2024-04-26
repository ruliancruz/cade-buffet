class EventTypesController < ApplicationController
  before_action :validate_buffet_creation, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_buffet_owner!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_event_type, only: [:edit, :update, :destroy]

  def show
    @event_type = EventType.find params[:id]
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new event_type_params
    @event_type.buffet = current_buffet_owner.buffet

    return redirect_to current_buffet_owner.buffet, notice: 'Tipo de Evento ' \
      'cadastrado com sucesso!' if @event_type.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'adicionar o tipo de evento.'

    render :new
  end

  def edit; end

  def update
    return redirect_to @event_type, notice: 'Tipo de evento atualizado com sucesso!' if
      @event_type.update event_type_params

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'atualizar o tipo de evento.'

    render :edit
  end

  def destroy
    redirect_to current_buffet_owner.buffet,
      notice: 'Tipo de evento excluído com sucesso!' if @event_type.destroy
  end

  private

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

  def set_event_type
    selected_event_type = EventType.find params[:id]

    return redirect_to current_buffet_owner.buffet if
      selected_event_type.nil? ||
      selected_event_type.buffet != current_buffet_owner.buffet

    @event_type = selected_event_type
  end
end
class EventTypesController < ApplicationController
  before_action :validate_buffet_creation, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_buffet_owner!, only: [:new, :create, :edit, :update, :destroy]
  before_action :select_event_type, only: [:show, :edit, :update, :destroy]
  before_action :validate_buffet_ownership, only: [:edit, :update, :destroy]

  def show
    return render :client_show if client_signed_in?
    render :visitor_show unless buffet_owner_signed_in?
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
      notice: 'Tipo de evento excluído com sucesso!' if @event_type.inactive!
  end

  private

  def event_type_params
    params.require(:event_type).permit :name,
                                       :description,
                                       :minimum_attendees,
                                       :maximum_attendees,
                                       :duration,
                                       :menu,
                                       :photo,
                                       :provides_alcohol_drinks,
                                       :provides_decoration,
                                       :provides_parking_service,
                                       :serves_external_address
  end

  def select_event_type
    @event_type = EventType.find params[:id]
  end

  def validate_buffet_ownership
    redirect_to current_buffet_owner.buffet if
      @event_type.nil? || @event_type.buffet != current_buffet_owner.buffet
  end
end
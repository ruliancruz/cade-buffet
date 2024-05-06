class OrdersController < ApplicationController
  before_action :validate_buffet_creation, only: [:index, :show, :new, :create, :edit]
  before_action :authenticate_client!, only: [:new, :create]

  def index
    return @orders = Order.order(:date) if client_signed_in?

    if buffet_owner_signed_in?
      @orders = Order.left_joins(:event_type)
        .where(event_type: { buffet_id: current_buffet_owner.buffet.id })
        .order :date

      return render :buffet_owner_index
    end

    redirect_to new_client_session_path
  end

  def show
    return @order = Order.find(params[:id]) if client_signed_in?

    if buffet_owner_signed_in?
      @order = Order.find params[:id]

      return render :buffet_owner_show
    end

    redirect_to new_client_session_path
  end

  def new
    event_type = EventType.find params[:event_type_id]

    return redirect_to event_type.buffet, notice: 'Este tipo de evento não ' \
      'pode ser contratado pois não possui preços-base cadastrados' if
      event_type.base_prices.empty?

    @order = Order.new event_type_id: event_type.id,
                       address: event_type.buffet.full_address if
                                event_type.serves_external_address
  end

  def create
    @order = Order.new params.require(:order)
      .permit(:date, :attendees, :details, :payment_option_id, :address)
      .merge! event_type_id: params.require(:event_type_id)

    @order.client = current_client
    @order.address = @order.event_type.buffet.full_address if @order.address.nil?
    @order.status = :waiting_for_evaluation
    @order.generate_code

    return redirect_to @order,
      notice: 'Pedido enviado com sucesso! Aguarde a avaliação do buffet!' if @order.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para fazer o pedido.'
    render :new
  end

  def edit
    return redirect_to @order = Order.find(params[:id]) if client_signed_in?

    if buffet_owner_signed_in? && Order.find(params[:id]).waiting_for_evaluation?
      @order = Order.find params[:id]

      return render :approve
    end

    redirect_to root_path
  end
end
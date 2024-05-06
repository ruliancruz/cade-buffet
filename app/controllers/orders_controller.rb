class OrdersController < ApplicationController
  before_action :authenticate_client!, only: [:index, :show, :new, :create]

  def index
    @orders = Order.order :date
  end

  def show
    @order = Order.find params[:id]
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
end
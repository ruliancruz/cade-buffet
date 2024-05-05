class OrdersController < ApplicationController
  before_action :authenticate_client!, only: [:show, :new, :create]

  def show
    @order = Order.find params[:id]
  end

  def new
    event_type = EventType.find params[:event_type_id]

    @order = Order.new event_type_id: event_type.id,
      address: event_type.buffet.full_address if event_type.serves_external_address
  end

  def create
    @order = Order.new params.require(:order)
      .permit(:date, :attendees, :details, :payment_option_id, :address)
      .merge! event_type_id: params.require(:event_type_id)

    @order.client = current_client
    @order.generate_code
    @order.waiting_for_evaluation!
    @order.address = @order.event_type.buffet.full_address if @order.address.nil?

    return redirect_to @order,
      notice: 'Pedido enviado com sucesso! Aguarde a avaliação do buffet' if @order.save!

    flash.now[:notice] = 'Preencha todos os campos corretamente para fazer o pedido.'
    render :new
  end
end
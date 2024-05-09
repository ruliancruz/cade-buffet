class OrdersController < ApplicationController
  before_action :validate_buffet_creation, only: [:index, :show, :new, :create, :edit]
  before_action :authenticate_client!, only: [:new, :create]
  before_action :select_order, only: [:show, :edit, :update]

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
    return if client_signed_in?
    return render :buffet_owner_show if buffet_owner_signed_in?

    redirect_to new_client_session_path
  end

  def new
    event_type = EventType.find params[:event_type_id]

    return redirect_to event_type.buffet, notice: 'Este tipo de evento não ' \
      'pode ser contratado pois não possui preços-base cadastrados' if
      event_type.base_prices.empty?

    return redirect_to event_type.buffet, notice: 'Este tipo de evento não pode ' \
      'ser contratado pois o buffet não possui meios de pagamento cadastrados' if
      event_type.buffet.payment_options.empty?

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
    return redirect_to @order if client_signed_in?
    return redirect_to root_path unless buffet_owner_signed_in?
    return redirect_to @order unless @order.waiting_for_evaluation?

    render :approve
  end

  def update
    order_params = params.require(:order).permit :date,
                                                 :attendees,
                                                 :details,
                                                 :address,
                                                 :price_adjustment,
                                                 :price_adjustment_description,
                                                 :expiration_date,
                                                 :event_type_id,
                                                 :payment_option_id,
                                                 :base_price_id

    if @order.update order_params
      @order.approved_by_buffet!
      return redirect_to @order, notice: 'Pedido aprovado com sucesso!'
    end

    flash.now[:notice] = 'Preencha todos os campos corretamente para aprovar o pedido.'
    render :approve
  end

  private

  def select_order
    @order = Order.find params[:id]
  end
end
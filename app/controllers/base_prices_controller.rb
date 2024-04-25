class BasePricesController < ApplicationController
  before_action :validate_buffet_creation, only: [:new, :create, :destroy]
  before_action :authenticate_buffet_owner!, only: [:new, :create, :destroy]
  before_action :set_base_price, only: [:destroy]

  def new
    @base_price = BasePrice.new event_type_id: params[:event_type_id]
  end

  def create
    @base_price = BasePrice.new base_price_params

    return redirect_to @base_price.event_type, notice: 'Preço-base ' \
      'cadastrado com sucesso!' if @base_price.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'cadastrar o preço-base.'

    render :new
  end

  def destroy
    redirect_to @base_price.event_type, notice: 'Preço-base removido com sucesso!' if
      @base_price.destroy
  end

  def base_price_params
    base_price_params = params.require(:base_price).permit :description,
                                                           :minimum,
                                                           :additional_per_person,
                                                           :extra_hour_value

    base_price_params.merge! event_type_id: params.require(:event_type_id)
  end

  def set_base_price
    selected_base_price = BasePrice.find params[:id]

    return redirect_to current_buffet_owner.buffet if
      selected_base_price.nil? ||
      selected_base_price.event_type.buffet != current_buffet_owner.buffet

    @base_price = selected_base_price
  end
end
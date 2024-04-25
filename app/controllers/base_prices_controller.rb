class BasePricesController < ApplicationController
  before_action :validate_buffet_creation, only: [:new, :create]
  before_action :authenticate_buffet_owner!, only: [:new, :create]

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

  def base_price_params
    base_price_params = params.require(:base_price).permit :description,
                                                           :minimum,
                                                           :additional_per_person,
                                                           :extra_hour_value

    base_price_params.merge! event_type_id: params.require(:event_type_id)
  end
end
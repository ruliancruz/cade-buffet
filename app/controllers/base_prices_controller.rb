class BasePricesController < ApplicationController
  before_action :validate_buffet_creation, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_buffet_owner!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_base_price, only: [:edit, :update, :destroy]

  def new
    @base_price = BasePrice.new event_type_id: params[:event_type_id]
  end

  def create
    @base_price = BasePrice.new full_base_price_params

    return redirect_to @base_price.event_type, notice: 'Preço-base ' \
      'cadastrado com sucesso!' if @base_price.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'cadastrar o preço-base.'

    render :new
  end

  def edit; end

  def update
    return redirect_to @base_price.event_type,
      notice: 'Preço-base atualizado com sucesso!' if
      @base_price.update base_price_params

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
      'atualizar o preço-base.'

    render :edit
  end

  def destroy
    redirect_to @base_price.event_type, notice: 'Preço-base removido com sucesso!' if
      @base_price.destroy
  end

  private

  def base_price_params
    params.require(:base_price).permit :description,
                                       :minimum,
                                       :additional_per_person,
                                       :extra_hour_value
  end

  def full_base_price_params
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
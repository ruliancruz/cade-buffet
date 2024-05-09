class PaymentOptionsController < ApplicationController
  before_action :validate_buffet_creation,
    only: [:new, :create, :edit, :update, :destroy]

  before_action :authenticate_buffet_owner!,
    only: [:new, :create, :edit, :update, :destroy]

  before_action :select_payment_option, only: [:edit, :update, :destroy]
  before_action :validate_buffet_ownership, only: [:edit, :update, :destroy]

  def new
    @payment_option = PaymentOption.new
  end

  def create
    @payment_option = PaymentOption.new payment_option_params
    @payment_option.buffet_id = current_buffet_owner.buffet.id

    return redirect_to current_buffet_owner.buffet,
      notice: 'Meio de pagamento cadastrado com sucesso!' if
      @payment_option.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
                         'cadastrar o meio de pagamento.'

    render :new
  end

  def edit; end

  def update
    return redirect_to current_buffet_owner.buffet,
      notice: 'Meio de pagamento atualizado com sucesso!' if
      @payment_option.update payment_option_params

    flash.now[:notice] = 'Preencha todos os campos corretamente para ' \
                         'atualizar o meio de pagamento.'

    render :edit
  end

  def destroy
    redirect_to current_buffet_owner.buffet,
      notice: 'Meio de pagamento removido com sucesso!' if
      @payment_option.inactive!
  end

  private

  def payment_option_params
    params.require(:payment_option).permit :name, :installment_limit
  end

  def select_payment_option
    @payment_option = PaymentOption.find params[:id]
  end

  def validate_buffet_ownership
    redirect_to current_buffet_owner.buffet if @payment_option.nil? ||
      @payment_option.buffet != current_buffet_owner.buffet
  end
end
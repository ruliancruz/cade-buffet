class BuffetsController < ApplicationController
  before_action :validate_buffet_creation, only: [:show, :edit, :update, :search]
  before_action :authenticate_buffet_owner!, only: [:new, :create, :edit, :update]
  before_action :set_buffet, only: [:edit, :update]

  def show
    @buffet = Buffet.find params[:id]

    render :visitor_show unless buffet_owner_signed_in?
  end

  def new
    return redirect_to root_path if current_buffet_owner&.buffet

    @buffet = Buffet.new
  end

  def create
    @buffet = Buffet.new buffet_params
    @buffet.buffet_owner = current_buffet_owner

    return redirect_to @buffet, notice: 'Buffet cadastrado com sucesso!' if @buffet.save

    flash.now[:notice] = 'Preencha todos os campos corretamente para cadastrar o buffet.'
    render :new
  end

  def edit; end

  def update
    return redirect_to @buffet, notice: 'Buffet atualizado com sucesso!' if
      @buffet.update buffet_params

    flash.now[:notice] = 'Preencha todos os campos corretamente para atualizar o buffet.'
    render :edit
  end

  def search
    @query = params.require(:query)

    @buffets = Buffet
      .joins('LEFT JOIN event_types ON event_types.buffet_id = buffets.id')
      .where('brand_name LIKE ? OR city LIKE ? OR event_types.name LIKE ?',
      "%#{@query}%", "%#{@query}%", "%#{@query}%")
      .distinct
      .order :brand_name
  end

  private

  def set_buffet
    @buffet = current_buffet_owner.buffet
  end

  def buffet_params
    params.require(:buffet).permit :corporate_name,
                                   :brand_name,
                                   :cnpj,
                                   :phone,
                                   :address,
                                   :district,
                                   :city,
                                   :state,
                                   :cep,
                                   :description
  end
end
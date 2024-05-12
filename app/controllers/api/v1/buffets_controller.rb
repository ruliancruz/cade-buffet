class Api::V1::BuffetsController < Api::V1::ApiController
  def index
    render status: 200, json: search.as_json(only:
       [:id,
       :brand_name,
       :phone,
       :address,
       :district,
       :city,
       :state,
       :cep,
       :description])
  end

  def show
    render status: 200, json: Buffet.find(params[:id]).as_json(only:
       [:id,
       :brand_name,
       :phone,
       :address,
       :district,
       :city,
       :state,
       :cep,
       :description])
  end

  private

  def search
    return Buffet.where('brand_name LIKE ?', "%#{params[:query]}%") if
      params.has_key?(:query) && !params[:query].blank?

    Buffet.all
  end
end
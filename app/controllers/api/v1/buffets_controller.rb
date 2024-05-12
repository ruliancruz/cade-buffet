class Api::V1::BuffetsController < ActionController::API
  def show
    buffet = Buffet.find params[:id]

    render status: 200, json: buffet.as_json(only:
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
end
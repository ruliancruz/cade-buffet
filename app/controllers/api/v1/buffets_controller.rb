class Api::V1::BuffetsController < ActionController::API
  def index
    render status: 200, json: Buffet.all.as_json(only:
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
    begin
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
    rescue
      render status: 404
    end
  end
end
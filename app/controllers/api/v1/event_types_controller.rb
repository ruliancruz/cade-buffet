class Api::V1::EventTypesController < Api::V1::ApiController
  def index
    render status: 200, json: Buffet.find(params[:buffet_id])
      .event_types.as_json(only:
        [:name,
        :description,
        :minimum_attendees,
        :maximum_attendees,
        :duration,
        :menu,
        :provides_alcohol_drinks,
        :provides_decoration,
        :provides_parking_service,
        :serves_external_address])
  end
end
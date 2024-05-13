class Api::V1::EventTypesController < Api::V1::ApiController
  DATE_REGEX = /\A\d{4}-\d{2}-\d{2}\z/

  def index
    render status: 200, json: Buffet.find(params[:buffet_id])
      .event_types.as_json(only:
        [:id,
        :name,
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

  def show
    event_type = EventType.find(params[:id])
    response = validate_parameters

    return render status: 422, json: response if response[:errors].any?

    render status: 200, json: event_type.buffet.availability_query(
      event_type, params[:date].to_date, params[:attendee_quantity].to_i)
  end

  private

  def validate_parameters
    response = { errors: [] }

    response[:errors] << 'Data precisa ser informada' if params[:date].nil?

    response[:errors] << 'Quantidade de Convidados precisa ser informada' if
      params[:attendee_quantity].nil?

    response[:errors] << 'Quantidade de Convidados precisa ser um número' unless
      (!!Float(params[:attendee_quantity]) rescue false)

    response[:errors] << 'Data precisa estar no formato yyyy-mm-dd' unless
      !!(params[:date] =~ DATE_REGEX)

    response
  end
end
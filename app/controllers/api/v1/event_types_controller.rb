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

    if params[:attendee_quantity].blank? || params[:attendee_quantity] == 'null'
      response[:errors] << 'Quantidade de Convidados precisa ser informada.'
    elsif (!Integer(params[:attendee_quantity]) rescue true)
      response[:errors] << 'Quantidade de Convidados precisa ser um número inteiro.'
    end

    if params[:date].blank? || params[:date] == 'null'
      response[:errors] << 'Data precisa ser informada.'
    else
      response[:errors] << 'Data precisa estar no formato yyyy-mm-dd.' unless
        params[:date] =~ DATE_REGEX

      response[:errors] << 'Data precisa ser atual ou futura.' if
        params[:date].to_date < Date.current
    end

    response
  end
end
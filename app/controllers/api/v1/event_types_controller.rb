class Api::V1::EventTypesController < Api::V1::ApiController
  DATE_REGEX = /\A\d{4}-\d{2}-\d{2}\z/

  def index
    render status: 200, json: Buffet.find(params[:buffet_id])
      .event_types.as_json(only: [
        :id,
        :name,
        :description,
        :minimum_attendees,
        :maximum_attendees,
        :duration,
        :menu,
        :provides_alcohol_drinks,
        :provides_decoration,
        :provides_parking_service,
        :serves_external_address
    ])
  end

  def show
    event_type = EventType.find(params[:id])
    response = validate_parameters

    return render status: 422, json: response if response[:errors].any?

    render status: 200, json: event_type.buffet
      .availability_query(
        event_type,
        params[:date].to_date,
        params[:attendee_quantity].to_i)
  end

  def create
    params[:provides_alcohol_drinks] =
      params[:provides_alcohol_drinks] == "true" ||
      params[:provides_alcohol_drinks] == true ? 1 : 0 if
      params[:provides_alcohol_drinks].present?

    params[:provides_decoration] =
      params[:provides_decoration] == "true" ||
      params[:provides_decoration] == true ? 1 : 0 if
      params[:provides_decoration].present?

    params[:provides_parking_service] =
      params[:provides_parking_service] == "true" ||
      params[:provides_decoration] == true ? 1 : 0 if
      params[:provides_parking_service].present?

    params[:serves_external_address] =
      params[:serves_external_address] == "true" ||
      params[:provides_decoration] == true ? 1 : 0 if
      params[:serves_external_address].present?

    event_type = EventType.new params.permit(
      :name,
      :description,
      :minimum_attendees,
      :maximum_attendees,
      :duration,
      :menu,
      :provides_alcohol_drinks,
      :provides_decoration,
      :provides_parking_service,
      :serves_external_address)
        .merge(buffet_id: params.require(:buffet_id))

    if event_type.save
      return render status: 201, json: event_type.as_json(only: [
        :id,
        :name,
        :description,
        :minimum_attendees,
        :maximum_attendees,
        :duration,
        :menu,
        :provides_alcohol_drinks,
        :provides_decoration,
        :provides_parking_service,
        :serves_external_address,
        :status,
        :created_at
      ])
    end

    render status: 422, json: { errors: event_type.errors.full_messages }
  end

  private

  def validate_parameters
    response = { errors: [] }

    if params[:attendee_quantity].blank? ||
      params[:attendee_quantity] == 'null'

      response[:errors] << 'Quantidade de Convidados precisa ser informada.'
    elsif (!Integer(params[:attendee_quantity]) rescue true)
      response[:errors] <<
        'Quantidade de Convidados precisa ser um número inteiro.'
    end

    if params[:date].blank? || params[:date] == 'null'
      response[:errors] << 'Data precisa ser informada.'
    elsif !(params[:date] =~ DATE_REGEX)
      response[:errors] << 'Data precisa estar no formato yyyy-mm-dd.'
    elsif params[:date].to_date < Date.current
      response[:errors] << 'Data precisa ser atual ou futura.'
    end

    response
  end
end
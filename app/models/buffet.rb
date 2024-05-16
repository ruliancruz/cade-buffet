class Buffet < ApplicationRecord
  belongs_to :buffet_owner
  has_many :payment_options
  has_many :event_types

  validates :corporate_name,
            :brand_name,
            :cnpj,
            :phone,
            :address,
            :district,
            :city,
            :state,
            :cep,
            presence: true

  validates :cnpj, length: { is: 14 }
  validates :phone, length: { in: 10..11 }
  validates :state, length: { is: 2 }
  validates :cep, length: { is: 8 }
  validates :cnpj, numericality: { only_integer: true }
  validates :phone, numericality: { only_integer: true }
  validates :cep, numericality: { only_integer: true }
  validates :cnpj, uniqueness: true
  validates :buffet_owner, uniqueness: true
  validates :cnpj, cnpj: { message: 'precisa ser válido' }

  def full_address
    "#{address} - #{district}, #{city} - #{state}, #{cep.insert(5, '-')}"
  end

  def formatted_phone
    return "(#{phone[0..1]}) #{phone[2..6]}-#{phone[7..10]}" if
      phone.length == 11

    "(#{phone[0..1]}) #{phone[2..5]}-#{phone[6..9]}"
  end

  def formatted_cnpj
    "#{cnpj[0..1]}.#{cnpj[2..4]}.#{cnpj[5..7]}/#{cnpj[8..11]}-#{cnpj[12..13]}"
  end

  def availability_query(event_type, date, attendees_quantity)
    return {
      available: available_at_date?(date),
      message: 'Erro! O Buffet não está disponível para esta data.' } unless
      available_at_date? date

    response = { available: available_at_date?(date), preview_prices: [] }

    event_type.base_prices.each do |base_price|
      response[:preview_prices] << {
        description: base_price.description,
        value: base_price.default_price(attendees_quantity) }
    end

    response
  end

  def available_at_date?(date_to_check)
    self.event_types.each do |event_type|
      event_type.orders.each do |order|
        return false if order[:date] == date_to_check &&
          !order.expired? &&
          (order.confirmed? || order.approved_by_buffet?)
      end
    end

    true
  end
end
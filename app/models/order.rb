class Order < ApplicationRecord
  belongs_to :client
  belongs_to :event_type
  belongs_to :payment_option, optional: true
  belongs_to :base_price, optional: true

  enum status: { waiting_for_evaluation: 2,
                 approved_by_buffet: 5,
                 confirmed: 8,
                 canceled: 11 }

  validates :date,
            :attendees,
            :details,
            :code,
            :status,
            :payment_option,
            :event_type,
            :client,
            presence: true

  validates :base_price,
            :expiration_date,
            presence: true,
            on: :update

  validates :price_adjustment,
    presence: { is: true, message: 'Ajuste de Preço não pode ficar em ' \
    'branco quando a Justificativa do Ajuste de Preço estiver preenchida' },
    if: -> { self.price_adjustment_description.present? }

  validates :attendees, numericality: { only_integer: true, greater_than: 0 }

  validate :date_is_actual_or_future
  validate :expiration_date_is_valid?

  def generate_code
    self.code = SecureRandom.alphanumeric 8
  end

  def final_price
    return default_price(self.base_price) + (self.price_adjustment || 0) unless
      self.waiting_for_evaluation?

    I18n.translate self.status
  end

  def default_price(base_price)
    base_price.minimum + total_additional_per_person(base_price)
  end

  private

  def total_additional_per_person(base_price)
    return base_price.additional_per_person *
      (self.attendees - self.event_type.minimum_attendees) if
      self.attendees > self.event_type.minimum_attendees

    0
  end

  def date_is_actual_or_future
    return unless self.date

    self.errors.add :date, 'precisa ser atual ou futura' if
      self.date < Date.current
  end

  def expiration_date_is_valid?
    return unless self.expiration_date && self.date

    self.errors.add :expiration_date, "precisa estar entre " \
      "#{I18n.localize Date.current} e #{I18n.localize self.date}" if
      self.expiration_date < Date.current || self.expiration_date > self.date
  end
end

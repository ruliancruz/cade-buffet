class Order < ApplicationRecord
  belongs_to :client
  belongs_to :event_type
  belongs_to :payment_option, optional: true
  belongs_to :base_price, optional: true

  has_many :messages

  enum status: { waiting_for_evaluation: 2,
                 approved_by_buffet: 5,
                 confirmed: 8,
                 canceled: 11 }

  before_validation :generate_code, on: :create

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
            on: :update, unless: -> { self.canceled? }

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
    return self.base_price.default_price(self.attendees) +
      (self.price_adjustment || 0) unless self.waiting_for_evaluation?

    I18n.translate self.status
  end

  def expired?
    return Date.current >= expiration_date if expiration_date
    false
  end

  private

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

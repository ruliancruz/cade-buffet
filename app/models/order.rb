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
            :event_type,
            :client,
            presence: true

  validates :attendees, numericality: { only_integer: true, greater_than: 0 }
  validate :date_is_actual_or_future

  def generate_code
    self.code = SecureRandom.alphanumeric 8
  end

  def final_price
    return default_price(self.base_price) + self.price_adjustment unless
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
    self.errors.add :date, 'precisa ser atual ou futura' unless
      self.date && self.date >= Date.today
  end
end

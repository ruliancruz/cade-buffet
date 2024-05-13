class BasePrice < ApplicationRecord
  belongs_to :event_type
  has_many :orders

  enum status: { active: 0, inactive: 1 }

  validates :description,
            :minimum,
            :additional_per_person,
            :event_type,
            :status,
            presence: true

  validates :minimum, numericality: { greater_than_or_equal_to: 0 }

  validates :additional_per_person,
    numericality: { greater_than_or_equal_to: 0 }

  def default_price(attendee_quantity)
    self.minimum + self.total_additional_per_person(attendee_quantity)
  end

  private

  def total_additional_per_person(attendee_quantity)
    return self.additional_per_person *
      (attendee_quantity - self.event_type.minimum_attendees) if
      attendee_quantity > self.event_type.minimum_attendees

    0
  end
end

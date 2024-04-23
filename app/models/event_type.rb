class EventType < ApplicationRecord
  belongs_to :buffet

  validates :name,
            :description,
            :minimum_attendees,
            :maximum_attendees,
            :duration,
            :menu,
            :provides_alcohol_drinks,
            :provides_decoration,
            :provides_parking_service,
            :serves_external_address,
            :buffet_id,
            presence: true

  validates :minimum_attendees, numericality: { only_integer: true }
  validates :maximum_attendees, numericality: { only_integer: true }
  validates :duration, numericality: { only_integer: true }
end

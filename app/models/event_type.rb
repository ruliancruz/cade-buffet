class EventType < ApplicationRecord
  belongs_to :buffet
  has_many :base_prices, dependent: :destroy

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

  validates :minimum_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :maximum_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def provides_alcohol_drinks_text
    provides_alcohol_drinks? ? 'Sim' : 'Não'
  end

  def provides_decoration_text
    provides_decoration? ? 'Sim' : 'Não'
  end

  def provides_parking_service_text
    provides_parking_service? ? 'Sim' : 'Não'
  end

  def serves_external_address_text
    serves_external_address? ? 'Sim' : 'Não'
  end
end

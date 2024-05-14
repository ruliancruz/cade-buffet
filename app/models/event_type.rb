class EventType < ApplicationRecord
  belongs_to :buffet
  has_many :base_prices, dependent: :destroy
  has_many :orders
  has_one_attached :photo

  enum status: { active: 1, inactive: 0 }

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
            :buffet,
            :status,
            presence: true

  validates :minimum_attendees, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }

  validates :maximum_attendees, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }

  validates :duration, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }

  def resized_photo
    self.photo.variant(resize_to_limit: [800, 800])
  end

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

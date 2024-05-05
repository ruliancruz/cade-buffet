class BasePrice < ApplicationRecord
  belongs_to :event_type
  has_many :orders

  validates :description,
            :minimum,
            :additional_per_person,
            :event_type,
            presence: true

  validates :minimum, numericality: { greater_than_or_equal_to: 0 }
  validates :additional_per_person, numericality: { greater_than_or_equal_to: 0 }
end

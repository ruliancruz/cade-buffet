class PaymentOption < ApplicationRecord
  belongs_to :buffet

  enum status: { active: 0, inactive: 1 }

  validates :name,
            :installment_limit,
            :status,
            presence: true

  validates :installment_limit, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def long_installment_limit
    return "Parcela em até #{installment_limit}x" if installment_limit > 1

    'À vista'
  end
end

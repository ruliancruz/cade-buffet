class PaymentOption < ApplicationRecord
  belongs_to :buffet

  validates :name,
            :installment_limit,
            presence: true

  validates :installment_limit, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def long_installment_limit
    return "Parcela em até #{installment_limit}x" if installment_limit > 1

    'À vista'
  end
end

class Buffet < ApplicationRecord
  belongs_to :buffet_owner
  has_many :payment_options

  validates :corporate_name,
            :brand_name,
            :cnpj,
            :phone,
            :address,
            :district,
            :city,
            :state,
            :cep,
            presence: true

  validates :cnpj, length: { is: 14 }
  validates :phone, length: { in: 10..11 }
  validates :state, length: { is: 2 }
  validates :cep, length: { is: 8 }
  validates :cnpj, numericality: { only_integer: true }
  validates :phone, numericality: { only_integer: true }
  validates :cep, numericality: { only_integer: true }
  validates :cnpj, uniqueness: true
  validates :buffet_owner, uniqueness: true

  def full_address
    "#{address} - #{district}, #{city} - #{state}, #{cep.insert(5, '-')}"
  end

  def formatted_phone
    return "(#{phone[0..1]}) #{phone[2..6]}-#{phone[7..10]}" if phone.length == 11

    "(#{phone[0..1]}) #{phone[2..5]}-#{phone[6..9]}"
  end

  def formatted_cnpj
    "#{cnpj[0..1]}.#{cnpj[2..4]}.#{cnpj[5..7]}/#{cnpj[8..11]}-#{cnpj[12..13]}"
  end
end
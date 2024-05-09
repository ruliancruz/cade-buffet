class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  validates :name,
            :cpf,
            presence: true

  validates :cpf, length: { is: 11 }

  validates :cpf, numericality: { only_integer: true,
                                  greater_than_or_equal_to: 0 }

  validates :cpf, uniqueness: true
  validates :cpf, cpf: { message: 'precisa ser válido' }
end

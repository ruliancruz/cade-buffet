require 'cpf_cnpj'

class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CPF.valid?(value)

    record.errors.add(attribute,
                      :invalid_cpf,
                      message: options[:message] || 'precisa ser válido',
                      value: value)
  end
end
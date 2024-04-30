require 'cpf_cnpj'

class CnpjValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return if CNPJ.valid? value

    record.errors.add attribute,
                      :invalid_cnpj,
                      message: options[:message] || 'precisa ser válido',
                      value: value
  end
end
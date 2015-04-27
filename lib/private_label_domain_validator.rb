class PrivateLabelDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless check(record)
      record.errors[attribute] << (options[:message] || "You must provide either a subdomain name or a domain")
    end
  end

  private
    def check(record)
      record.namespace.present? || record.domain.present? 
    end
end


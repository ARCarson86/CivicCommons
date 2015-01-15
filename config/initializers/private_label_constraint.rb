class PrivateLabelConstraint
  def self.matches? request
    request.subdomains.last == "pl" or matching_privatelabel?(request.host)
  end

  def self.matching_privatelabel?(host)
    PrivateLabel.where(domain: host).any?
  end
end

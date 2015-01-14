class PrivateLabelConstraint
  def self.matches? request
    request.subdomains.last == "pl" or matching_privatelabel?(request.host)
  end

  def self.matching_privatelabel?(host)
    host != "theciviccommons.com" or PrivateLabel.where(domain: host).any?
  end
end

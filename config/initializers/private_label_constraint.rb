class PrivateLabelConstraint
  def self.matches? request
    ["privatelabel", "pl"].include? request.subdomains.last or matching_privatelabel?(request.host)
  end

  def self.matching_privatelabel?(host)
    PrivateLabel.where(domain: host).any?
  end
end

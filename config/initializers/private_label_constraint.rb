class PrivateLabelConstraint
  def self.matches?(request)
    !!load_private_label(request)
  end

  def self.load_private_label(request)
    find_by = { domain: request.host }
    find_by = { namespace: request.subdomains.first } if (request.subdomains.length > 1 && ["privatelabel", "pl"].include?(request.subdomains.last))
    Swayze.current_private_label = PrivateLabel.first(conditions: find_by)
    Swayze.current_private_label
  end
end

Obscenity.configure do |config|
  config.blacklist   = "config/badwords.yml"
  config.replacement = :stars
end
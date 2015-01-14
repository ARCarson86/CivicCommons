##
# Convenience method to provide the content of a specific 
# fixture file in a test.
#
# @param path [String] The path to the fixture file to get
#   content from; should be relative to the fixture directory
#
# @return The contents of the file in the path
def fixture_content(path)
  File.open(File.join(Rails.root, 'spec', 'fixtures' + path, 'rb')) { |f| f.read }
end

def mask_with_intercept_email(address, subject = nil)
  cc = Civiccommons::Config
  if cc.mailer['intercept']
    subject = "[#{Rails.env.capitalize} - [\"#{address}\"]] #{subject}" unless subject.nil?
    address = cc.mailer['intercept_email']
  end
  return ( subject ? [ address, subject ] : address )
end

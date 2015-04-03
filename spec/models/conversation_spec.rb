require 'rails_helper'
require 'support/private_label_scopable_shared_examples'

describe Conversation do
  it_behaves_like 'a private label scoped model'
end

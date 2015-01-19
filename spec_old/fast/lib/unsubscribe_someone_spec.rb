$LOAD_PATH << '.'
require 'spec/fast/helper'
require 'lib/unsubscribe_someone'
class TestUnsubscribeSomeone
  include UnsubscribeSomeone
  attr_accessor(:daily_digest)
end

describe UnsubscribeSomeone do
  let(:subject) { TestUnsubscribeSomeone.new }
  before do
    subject.stub(:save)
    subject.daily_digest = true
    subject.unsubscribe_from_daily_digest
  end
  describe 'unsubscribing from the daily digest' do
    it 'unsubscribes the person from the daily digest' do
      subject.should_not be_subscribed_to_daily_digest
    end
    it 'force saves the person' do
      subject.should have_received(:save).with(:validate => false)
    end
  end
end

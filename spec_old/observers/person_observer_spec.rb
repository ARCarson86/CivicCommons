require 'spec_helper'

describe PersonObserver do

  before :all do
    ActiveRecord::Observer.enable_observers
  end

  after :all do
    ActiveRecord::Observer.disable_observers
  end

  describe "On Save" do

    it "updates the person's avatar_url attribute" do
      AvatarService.should_receive(:update_avatar_url_for).with(an_instance_of(Person))

      person = Person.new(first_name: "Civic", last_name: "Commons", email: "cc_test@example.com", zip_code: "44113", password: "123456")
      person.save
    end

  end

end

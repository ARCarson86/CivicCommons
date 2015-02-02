require 'spec_helper'

class TestError < CCML::Error::Base
end

describe CCML::Error::Base do

  context "nested exceptions" do

    it "has a nil trace when there are no nested exceptions" do
      TestError.new.trace.should be_instance_of Array
      TestError.new.trace.should be_empty
    end

    it "exposes nested exceptions through the trace method" do
      begin
        begin
          begin
            begin
              raise TestError, "First"
            rescue => error
              raise TestError, "Second"
            end
          rescue => error
            raise TestError, "Third"
          end
        rescue => error
          raise TestError, "Fourth"
        end
      rescue => error
        error.trace.should be_instance_of Array
        error.trace.size.should == 3
        error.trace.pop.message.should == "Third"
        error.trace.pop.message.should == "Second"
        error.trace.pop.message.should == "First"
        error.trace.pop.should be_nil
      end
    end

  end

end

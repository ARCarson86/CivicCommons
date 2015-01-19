require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class TestBaseTag < CCML::Tag::SingleTag
  def index
    return "Hello World!"
  end
end

describe CCML::Tag::Base do

  before(:all) do

    @http_url = 'http://www.theciviccommons.com:3000'

    @https_url = 'https://www.theciviccommons.com:3000'

    @url_no_path_no_qs = 'http://www.theciviccommons.com'

    @url_no_path_unformatted_qs = 'http://www.theciviccommons.com:3000/?unformatted_query_string'

    @url_no_path_formatted_qs_one_field = 'http://www.theciviccommons.com?field=value'

    @url_no_path_formatted_qs_many_fields = 'http://www.theciviccommons.com:3000?field1=value1&field2=value2&field3=value3'

    @url_with_path_one_segment_no_qs = 'http://www.theciviccommons.com:3000/segment_0'

    @url_with_path_one_segment_unformatted_qs = 'http://www.theciviccommons.com/segment_0?unformatted_query_string'

    @url_with_path_one_segment_qs_one_field = 'http://www.theciviccommons.com:3000/segment_0?field=value'

    @url_with_path_one_segment_qs_many_fields = 'http://www.theciviccommons.com/segment_0?field1=value1&field2=value2&field3=value3'

    @url_with_path_multiple_segments_no_qs = 'http://www.theciviccommons.com:3000/segment_0/segment_1/segment_2/'

    @url_with_path_multiple_segments_unformatted_qs = 'http://www.theciviccommons.com/segment_0/segment_1/segment_2/?unformatted_query_string'

    @url_with_path_multiple_segments_qs_one_field = 'http://www.theciviccommons.com:3000/segment_0/segment_1/segment_2/?field=value'

    @url_with_path_multiple_segments_qs_many_fields = 'http://www.theciviccommons.com/segment_0/segment_1/segment_2/?field1=value1&field2=value2&field3=value3'

  end

  context "url parsing" do

    context "no url" do

      before(:all) do
        @tag = TestBaseTag.new(nil)
      end

      it "sets the url to blank" do
        @tag.url.should be_blank
      end

      it "sets all protocol accessors to false" do
        @tag.http?.should be_false
        @tag.https?.should be_false
      end

      it "sets the host to blank" do
        @tag.host.should be_blank
      end

      it "sets the port to blank" do
        @tag.port.should be_blank
      end

      it "sets the path to blank" do
        @tag.path.should be_blank
      end

      it "sets the query string to blank" do
        @tag.query_string.should be_blank
      end

      it "returns an empty array for the segment collection" do
        @tag.segments.should be_kind_of Array
        @tag.segments.should be_empty
      end

      it "returns an empty hash for the query field collection" do
        @tag.fields.should be_kind_of Hash
        @tag.fields.should be_empty
      end

    end

    context "protocol" do

      it "recognizes an http url" do
        tag = TestBaseTag.new({}, @http_url)
        tag.http?.should be_true
        tag.https?.should be_false
      end

      it "recognizes an https url" do
        tag = TestBaseTag.new({}, @https_url)
        tag.http?.should be_false
        tag.https?.should be_true
      end

    end

    context "host" do

      it "correctly extracts the host" do
        TestBaseTag.new({}, @http_url).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @https_url).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).host.should == 'www.theciviccommons.com'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).host.should == 'www.theciviccommons.com'
      end

    end

    context "port" do

      it "correctly extracts the port" do
        TestBaseTag.new({}, @http_url).port.should == '3000'
        TestBaseTag.new({}, @https_url).port.should == '3000'
        TestBaseTag.new({}, @url_no_path_no_qs).port.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).port.should == '3000'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).port.should be_blank
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).port.should == '3000'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).port.should == '3000'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).port.should be_blank
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).port.should == '3000'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).port.should be_blank
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).port.should == '3000'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).port.should be_blank
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).port.should == '3000'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).port.should be_blank
      end

    end

    context "resource" do

      it "correctly extracts the resource" do
        TestBaseTag.new({}, @http_url).resource.should be_blank
        TestBaseTag.new({}, @https_url).resource.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).resource.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).resource.should == '/?unformatted_query_string'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).resource.should == '?field=value'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).resource.should == '?field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).resource.should == '/segment_0'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).resource.should == '/segment_0?unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).resource.should == '/segment_0?field=value'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).resource.should == '/segment_0?field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).resource.should == '/segment_0/segment_1/segment_2/'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).resource.should == '/segment_0/segment_1/segment_2/?unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).resource.should == '/segment_0/segment_1/segment_2/?field=value'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).resource.should == '/segment_0/segment_1/segment_2/?field1=value1&field2=value2&field3=value3'
      end

    end

    context "path" do

      it "correctly extracts the path" do
        TestBaseTag.new({}, @http_url).path.should be_blank
        TestBaseTag.new({}, @https_url).path.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).path.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).path.should be_blank
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).path.should be_blank
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).path.should be_blank
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).path.should == '/segment_0'
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).path.should == '/segment_0'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).path.should == '/segment_0'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).path.should == '/segment_0'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).path.should == '/segment_0/segment_1/segment_2'
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).path.should == '/segment_0/segment_1/segment_2'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).path.should == '/segment_0/segment_1/segment_2'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).path.should == '/segment_0/segment_1/segment_2'
      end

    end

    context "query string" do

      it "correctly extracts the query string" do
        TestBaseTag.new({}, @http_url).query_string.should be_blank
        TestBaseTag.new({}, @https_url).query_string.should be_blank
        TestBaseTag.new({}, @url_no_path_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_no_path_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).query_string.should be_blank
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).query_string.should == 'unformatted_query_string'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).query_string.should == 'field=value'
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).query_string.should == 'field1=value1&field2=value2&field3=value3'
      end

    end

    context "segments" do

      it "correctly extracts the correct segment values" do
        TestBaseTag.new({}, @http_url).segments.should be_empty
        TestBaseTag.new({}, @https_url).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_no_qs).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_unformatted_qs).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_formatted_qs_one_field).segments.should be_empty
        TestBaseTag.new({}, @url_no_segments_formatted_qs_many_fields).segments.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).segments.should == [ 'segment_0' ]
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).segments.should == [ 'segment_0' ]
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).segments.should == [ 'segment_0' ]
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).segments.should == [ 'segment_0' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).segments.should == [ 'segment_0', 'segment_1', 'segment_2' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).segments.should == [ 'segment_0', 'segment_1', 'segment_2' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).segments.should == [ 'segment_0', 'segment_1', 'segment_2' ]
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).segments.should == [ 'segment_0', 'segment_1', 'segment_2' ]
      end
    end

    context "fields" do

      it "correctly extracts the correct key/value pairs" do
        TestBaseTag.new({}, @http_url).fields.should be_empty
        TestBaseTag.new({}, @https_url).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_no_path_formatted_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_no_path_formatted_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
        TestBaseTag.new({}, @url_with_path_one_segment_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_one_segment_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_with_path_one_segment_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
        TestBaseTag.new({}, @url_with_path_multiple_segments_no_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_multiple_segments_unformatted_qs).fields.should be_empty
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_one_field).fields.should == { :field => 'value' }
        TestBaseTag.new({}, @url_with_path_multiple_segments_qs_many_fields).fields.should == { :field1 => 'value1', :field2 => 'value2', :field3 => 'value3' }
      end

    end

    context "updating options from url" do

      before(:all) do
        @url = 'http://www.theciviccommons.com/issues/flats-redevelopment/explore/?first_name=John&last_name=Doe&email=john@doe.com'
      end

      it "correctly updates options from url segments" do
        opts = {
          :s0 => 'segment_0',
          :s1 => 'segment_1',
          :s2 => 'segment_2',
          :s3 => 'segment_3',
          :ls => 'last_segment',
        }
        tag = TestBaseTag.new(opts, @url)
        tag.opts[:s0].should == 'issues'
        tag.opts[:s1].should == 'flats-redevelopment'
        tag.opts[:s2].should == 'explore'
        tag.opts[:s3].should be_blank
        tag.opts[:ls].should == 'explore'
      end

      it "correctly updates options from query string fields" do
        opts = {
          :f0 => 'field_first_name',
          :f1 => 'field_last_name',
          :f2 => 'field_email',
          :f3 => 'field_does_not_exist',
          :qs => 'query_string',
        }
        tag = TestBaseTag.new(opts, @url)
        tag.opts[:f0].should == 'John'
        tag.opts[:f1].should == 'Doe'
        tag.opts[:f2].should == 'john@doe.com'
        tag.opts[:f3].should be_blank
        tag.opts[:qs].should == 'first_name=John&last_name=Doe&email=john@doe.com'
      end

      it "does not change other options" do
        opts = {
          :s0 => 'not_segment_0',
          :s1 => 'not_segment_1',
          :s2 => 'not_segment_2',
          :s3 => 'not_segment_3',
          :f0 => 'not_field_first_name',
          :f1 => 'not_field_last_name',
          :f2 => 'not_field_email',
          :f3 => 'not_field_does_not_exist',
        }
        tag = TestBaseTag.new(opts, @url)
        tag.opts[:s0].should == 'not_segment_0'
        tag.opts[:s1].should == 'not_segment_1'
        tag.opts[:s2].should == 'not_segment_2'
        tag.opts[:s3].should == 'not_segment_3'
        tag.opts[:f0].should == 'not_field_first_name'
        tag.opts[:f1].should == 'not_field_last_name'
        tag.opts[:f2].should == 'not_field_email'
        tag.opts[:f3].should == 'not_field_does_not_exist'
      end

      it "correctly sets segment and field variables when no segments or fields exist" do
        opts = {
          :s0 => 'segment_0',
          :ls => 'last_segment',
          :f0 => 'field_first_name',
          :qs => 'query_string',
        }
        tag = TestBaseTag.new(opts, 'http://www.theciviccommons.com')
        tag.opts[:s0].should be_blank
        tag.opts[:ls].should be_blank
        tag.opts[:f0].should be_blank
        tag.opts[:qs].should be_blank
      end

    end

  end

end

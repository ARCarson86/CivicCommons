require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class TestPairTag < CCML::Tag::TagPair
  attr_accessor :obj
  def single_hash
    return process_tag_body(@opts)
  end
  def array_of_hashes
    opts = [ @opts, @opts, @opts ]
    return process_tag_body(opts)
  end
  def single_object
    return process_tag_body(@obj)
  end
  def array_of_objects
    objs = [ @obj, @obj, @obj ]
    return process_tag_body(objs)
  end
  def active_record_set
    objs = Person.find(:all, limit: 3)
    return process_tag_body(objs)
  end
  def active_record_assoc
    objs = ContentItem.all
    return process_tag_body(objs)
  end
  def associations
    objs = {
      props: {
        first: "Jerry",
        last: "D'Antonio"
      }
    }
    return process_tag_body(objs)
  end
  def arrays
    objs = {
      props: [1, 2, 3, 4, 5]
    }
    return process_tag_body(objs)
  end
  def array_associations
    objs = {
      props: {
        inner: [
          { first: "Jerry"},
          { last: "D'Antonio" }
        ]
      }
    }
    return process_tag_body(objs)
  end
end

describe CCML::Tag::TagPair do

  context "process_tag" do

    before(:all) do

      @test_date = Time.utc(2011, 4, 5, 23, 58, 00)

      @person = FactoryGirl.build(:admin_person, :id => 1, :first_name => 'John', :last_name => 'Doe', :confirmed_at => @test_date)

      @ccml_options = {
        :id => @person.id.to_s,
        :first_name => @person.first_name,
        :last_name => @person.last_name,
      }

      @ccml_template = "{ccml:test_pair id='1' first_name='John' last_name=\"Doe\"}<h1>ID {id}</h1><p>Hello, {first_name} {last_name}!</p>{/ccml:test_pair}"

      @ccml_tag_body = "<h1>ID {id}</h1><p>Hello, {first_name} {last_name}!</p>"

      @ccml_processed_once = "<h1>ID 1</h1><p>Hello, John Doe!</p>"

      @ccml_processed_twice = "<h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p>"

      @ccml_processed_thrice = "<h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p><h1>ID 1</h1><p>Hello, John Doe!</p>"

      @ccml_people = "{ccml:test_pair:active_record_set}<h1>ID {id}</h1><p>Hello, {first_name} {last_name}!</p>{/ccml:test_pair:active_record_set}"

      @ccml_people_processed = /<h1>ID \d+<\/h1><p>Hello, \w+ \w+!<\/p><h1>ID \d+<\/h1><p>Hello, \w+ \w+!<\/p><h1>ID \d+<\/h1><p>Hello, \w+ \w+!<\/p>/

      @ccml_content = "{ccml:test_pair:active_record_assoc}<h1>{title}</h1><p>Author: {author.name}</p>{/ccml:test_pair:active_record_assoc}"

      @ccml_content_processed = /<h1>.+<\/h1><p>Author: \w+ \w+<\/p>/

    end

    context "without conditionals" do

      before(:all) do
        @tag = TestPairTag.new(@ccml_options)
        @tag.tag_body = @ccml_tag_body
      end

      it "processes a simple hash" do
        @tag.single_hash.should == @ccml_processed_once
      end

      it "processes an array of simple hashes" do
        @tag.array_of_hashes.should == @ccml_processed_thrice
      end

      it "processes an object" do
        @tag.obj = @person
        @tag.single_object.should == @ccml_processed_once
      end

      it "processes an array of objects" do
        @tag.obj = @person
        @tag.array_of_objects.should == @ccml_processed_thrice
      end

      context "using ActiveRecord" do

        before(:each) do
          (1..4).each do
            FactoryGirl.create(:admin_person, first_name: 'John', last_name: 'Doe')
          end
          FactoryGirl.create(:content_item, :author => Person.first)
        end

        it "processes an active record set" do
          @tag = TestPairTag.new(nil)
          @tag.tag_body = @ccml_people
          @tag.active_record_set.should =~ @ccml_people_processed
        end

        it "processes an active record property through an association" do
          @tag = TestPairTag.new(nil)
          @tag.tag_body = @ccml_content
          @tag.active_record_assoc.should =~ @ccml_content_processed
        end

      end

      context "complext object models" do

        it "processes attributes through associations" do
          @tag = TestPairTag.new(nil)
          @tag.tag_body = "{props.first} {props.last}"
          @tag.associations.should =~ /Jerry D'Antonio/
        end

        it "process array attributes" do
          @tag = TestPairTag.new(nil)
          @tag.tag_body = "{props[0]}, {props[1]}, {props[2]}, {props[3]}, {props[4]}"
          @tag.arrays.should =~ /1, 2, 3, 4, 5/
        end

        it "processes array attributes through associations" do
          @tag = TestPairTag.new(nil)
          @tag.tag_body = "{props.inner[0].first} {props.inner[1].last}"
          @tag.array_associations.should =~ /Jerry D'Antonio/
        end

      end

    end

    context "with conditionals" do

      before(:all) do

        @tag = TestPairTag.new({})

      @full_conditional =
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{if:elsif first_name == 'Paul'}
<h2>Ebony and ivory.</h2>
{if:elseif first_name == 'George'}
<h3>{first_name}, you are the quiet one.</h3>
{if:else}
<h4>You must be {first_name}!</h4>
{/if}"

      @if_conditional
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{/if}"

      @multiple_conditionals =
"{if first_name == 'John'}
<h1>I am the walrus.</h1>
{if:elsif first_name == 'Paul'}
<h2>Ebony and ivory.</h2>
{if:elseif first_name == 'George'}
<h3>{first_name}, you are the quiet one.</h3>
{if:else}
<h4>You must be {first_name}!</h4>
{/if}

{if first_name == 'John'}
<h1>I am the walrus.</h1>
{/if}"
      end

      it "processes an 'if' phrase" do
        @tag.obj = FactoryGirl.build(:registered_user, :first_name => 'John')
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h1>I am the walrus.</h1>\n"
      end

      it "processes an 'elsif' phrase (Ruby-style)" do
        @tag.obj = { 'first_name' => 'Paul' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h2>Ebony and ivory.</h2>\n"
      end

      it "processes an 'elseif' phrase (ExpressionEngine-style)" do
        @tag.obj = { :first_name => 'George' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h3>George, you are the quiet one.</h3>\n"
      end

      it "processes an 'else' phrase" do
        @tag.obj = { :first_name => 'Ringo' }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h4>You must be Ringo!</h4>\n"
      end

      it "processes an expression against a non-existent property" do
        @tag.obj = { }
        @tag.tag_body = @full_conditional
        @tag.single_object.should == "\n<h4>You must be !</h4>\n"
      end

      it "processes a conditional with no true branches" do
        @tag.obj = { }
        @tag.tag_body = @if_conditional
        @tag.single_object.should be_blank
      end

      it "processes an multiple conditionals" do
        @tag.obj = FactoryGirl.build(:registered_user, :first_name => 'John')
        @tag.tag_body = @multiple_conditionals
        @tag.single_object.should == "\n<h1>I am the walrus.</h1>\n\n\n\n<h1>I am the walrus.</h1>\n"
      end

    end

    context "with date variable formatting" do

      before(:all) do

        @tag = TestPairTag.new({})

        @tag_pair_with_date_var_formatting = "{ccml:test_pair:single_hash}{date format='%m-%d-%Y %I:%M %p'}{/ccml:test_pair:single_hash}"
        @tag_body_with_date_var_formatting = "{date format='%m-%d-%Y %I:%M %p'}"
      end

      it "properly formats a date variable" do
        @tag.obj = { :date => @test_date }
        @tag.tag_body = @tag_body_with_date_var_formatting
        @tag.single_object.should == '04-05-2011 11:58 PM'
      end

      it "properly formats an ActiveRecord date variable" do
        @tag.obj = { :date => @person.confirmed_at.utc }
        @tag.tag_body = @tag_body_with_date_var_formatting
        @tag.single_object.should == '04-05-2011 11:58 PM'
      end

      it "ignores format for non-date variable" do
        @tag.obj = { :date => 'garbage' }
        @tag.tag_body = @tag_body_with_date_var_formatting
        @tag.single_object.should == 'garbage'
      end

    end

  end

end

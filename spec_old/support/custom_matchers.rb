module CustomMatchers
  
  def match_errors(object, field=nil, pattern=//)
    if field
      assert object.errors[field]
      assert_match(pattern, object.errors[field].to_s)
    else
      assert ! object.valid?
      assert_match(pattern, object.errors.full_messages.join(", "))
    end
  end
  
  def content_for(name) 
    view.content_for(name.to_sym)
  end
  
  RSpec::Matchers.define :have_validation_error do |field=nil, pattern=//|
    match do |object|
      assert ! object.valid?
      match_errors(object,field,pattern)
    end

    failure_message_for_should_not do |object|
      "#{object.class} should not have errors#{" on #{field}" if field}, but found errors: #{object.errors.collect{|key,error| "#{key}: #{error}"}}"
    end
  end
  
  RSpec::Matchers.define :have_generic_error do |field=nil, pattern=//|
    match do |object|
      match_errors(object,field,pattern)
    end
  end
  
  RSpec::Matchers.define :have_value do |expected|
    match do |object|
      assert_match(object.value, expected)
    end
  end
end

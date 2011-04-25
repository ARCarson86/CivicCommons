#--
# = CCML (Civic Commons Markup Language)
#
# CCML is a minimal markup language based on ExpressionEngine tag syntax. It is
# intended to allow web designers on the Civic Commons project easily embed
# server-side dynamic behavior into an HTML output stream. CCML was originally
# created for Managed Issues but may be leveraged for other features. 
#
# == Syntax
#
# The syntax of a CCML tag is identical to the syntax of an ExpressionEngine
# template tag except that "exp" in the ExpressionEngine tag is replaced by
# "ccml" in the CCML tag. Tags can be either single tags or tag pairs. Single
# tags simply generate string data in place of the tag. Tag pairs are iterative.
# They loop over the body of the tag pair zero or more times and generate more
# complex string output. The initial implementation will only support single
# tags. The general syntax of a single tag is:
#
# <code>{ccml:tag_class:method opt='value' opt='value' opt='value'}</code>
#
# Tag pairs have two tags: an open tag and a close tag. The open tag follows
# the same format as a single tag. The close tag has the following syntax:
#
# <code>{/ccml:tag_class:method}</code>
#
# An example of a single tag with no method name and a parameter list is:
#
# <code>{ccml:partial path='conversation/tile'}</code>
#
# For more information on the ExpressionEngine tag syntax see the documentation
# at http://expressionengine.com/user_guide/overview/tags.html. Only the tag
# syntax has been borrowed from ExpressionEngine. The library design and all
# programming are original.
#
# == Architecture
#
# CCML processing is handled by a series of modules and classes in the Rails
# "lib" directory. All classes must exist within the CCML module. The CCML
# module has a single public method called parse. The parse method takes a
# single parameter, a string representing the CCML data to be parsed. The
# return value is a text (HTML, XML, JSON, etc.) string capable of being
# inserted into a Rails HTTP response.
#
# The class *CCML::Error::TemplateError* is the base class for all template
# parsing exceptions. The parse method of the CCML module will raise an
# instance of this class if an error is encountered during parsing. Parsing
# of the CCML template will cease on the first error.
#
# === Parsing Process
#
# The CCML parsing process is designed to be very simple yet very flexible.
# Each CCML tag maps to an instance of a *CCML::Tag::Base* subclass.
# *CCML::Tag::Base* is an abstract class and cannot be used in a template.
# Using *CCML::Tag::Base* in a template raises a TagBaseClassInTemplate error.
# *CCML::Tag::Single* and *CCML::Tag::Pair* are abstract subclass of Base used
# as base subclasses for single tags and tag pairs respectfully. Their direct
# use will also result in a TagBaseClassInTemplate exception being raised.
#
# *CCML::Tag* defines a constructor with an optional hash parameter called opts
# The value of the opts parameter is assigned to an instance data member of the
# same name. If the opts parameter is missing or is not a Hash object the data
# member is set to an empty hash. Subclasses of Tag can always expect the opts
# data member to not be nil and to be a hash. *CCML::Tag::Base* defines one
# instance method called index. The index method takes no parameters and returns
# a string.
#
# During the parsing process the parser replaces every instance of a valid tag
# with string data generated by an associated tag class instance. The parser
# does not examine the tag output, it simply injects it into the output stream
# in place of the tag. The general steps for processing a valid tag are:
#
# * Parse for tag pairs the single tags the malformed tags.
# * Raise _MalformedTagError_ if a malformed tag is encountered.
# * Create an instance of the appropriate tag subclass, passing the options hash as the constructor parameter.
# * Raise _TagClassNotFoundError_ if the appropriate tag class does not exist.
# * If a method name does not appear in the tag call the index method of the tag object.
# * If a method name appears in the tag call the appropriate method of the tag object.
# * If the method does not exist on the tag object raise _TagMethodNotFoundError_.
# * If the tag method returns without raising an exception replace the tag in the content with the return value of the method, converting to a string if necessary.
#
# == URL Segments and Query String Fields
#
# Much like ExpressionEngine, the CCML system also performs URL parsing. If the
# URL parameter is passed to the CCML _parse_ method the the URL will, in turn,
# be passed to the tag constructor for parsing. The constructor will break the
# URL down into its component parts and make them accessible through various
# attribute readers. In addition, *CCML::Tag::Base* will perform additional
# processing of the options array and substitue values based on special URL
# path segment and query string field variables. This processing is based on
# ExpressionEngine's URL segment variables but is much more powerful. More
# information regarding ExpressionEngine URL segment variables can be found at
# http://expressionengine.com/user_guide/templates/globals/url_segments.html.
#
# === URL Format
#
# CCML uses its own nomenclature to define the structure of a URL. The basic
# structure is:
#
# <code>protocol://host/resourse</code>
#
# The resource is further subdivided into the _path_ and the _query string_. The
# _path_ is further subdivided into URL _segments_. If the query string is
# formatted in key/value pairs using then it is further subdivided into fields
# (see below).
#
# The following URL:
#
# <code>http://www.theciviccommons.com/segment_0/segment_1/segment_2/?field1=value1&field2=value2&field3=value3</code>
#
# is parsed as:
#
# * Protocol: _http_
# * Host: _www.theciviccommons.com_
# * Resource: _/segment_0/segment_1/segment_2/?field1=value1&field2=value2&field3=value3_
# * Path: _/segment_0/segment_1/segment_2_
# * Query String: _field1=value1&field2=value2&field3=value3_
#
# === URL Segment Variables
#
# Because Rails uses the URL path as the basis for routing it is essential that
# CCML tags have access to the path when being used in a Web environment. The
# special URL segment variables provide this access. The tag base class will
# parse the URL _path_ variable into an array of segments similar to
# ExpressionEngine. CCML uses the same format of the word segment followed by
# an underscore followed by the index value (i.e. 'segment_0'). The main
# differences between ExpressionEngine and CCML URL segment variables are that
# CCML path segments begin at index zero (ExpressionEngine begins at index one)
# and CCML has no maximum index (ExpressionEngine only supports nine URL segment
# variables).
#
# CCML URL segment variables are available in two contexts: tag options and
# tag pair attributes. On tag creation any options with segment variables for
# values will be updated with the corresponding path segment value. For example,
# the tag
#
# <code>{ccml:issue id='segment_1'}</code>
#
# under the URL
#
# <code>http://www.theciviccommons.com/issues/1</code>
#
# will have the value of the _id_ option automatically set to 1.
#
# As with ExpressionEngine, CCML supports the special segment variable
# 'last_segment' which always maps to the last URL path segment.
#
# === Query String Field Variables
#
# Althought the query string is not used in Rails as often as it is used in
# environments, CCML still provides support for the query string similar to the
# support it provides for path segments. Accessing this functionality requires
# the query string to be formatted as key/value pairs with pairs separated by
# ampersands and keys separated from values by equal signs. When the query
# string is formatted this way it is parsed into a _fields_ hash. Hash keys
# are symbolized versions of the keys from the query string.
#
# CCML tags have access to a special set of field variables similar to path
# segment variables and available in the same contexts. Field variables, when
# used for tag option values or as tag pair attributes, follow the format
# 'field_' followed by the field name. On tag creation any options with field
# variables for values will be updated with the corresponding field value.
# For example, the tag
#
# <code>{ccml:issue id='field_id'}</code>
#
# under the URL
#
# <code>http://www.theciviccommons.com/issues?id=1</code>
#
# will have the value of the _id_ option automatically set to 1.
# 
# The special field variable 'query_string' will always map to the entire
# query string, whether or not it is formatted in key/value pairs.
#
# == Tag Pair Variable Processing
#
# CCML tag pair processing is very robust and supports several advanced
# processing features. These features allow for very granular control of the
# tag output without the need to write complex processing login within the
# tag class itself.
#
# The magic occurs in the *CCML::Tag::TagPair#process_tag_body* method. Any
# tag pair subclass can pass a hash, an object with attribute readers, an
# array of hashes, and array of objects, an ActiveRecord object, or an
# ActiveRecord collection to this method and method will return the tag
# body parsed against the object(s). Tags needing more complex processing
# can access the *CCML:Tag::TagPair#tag_body* reader (*@tag_body* instance
# variable) and process it directly. This approach is not recommended.
#
# === Conditional Processing
#
# CCML tag pair variables support ExpressionEngine-style conditional processing.
# Conditional expressions allow very granular control of the tag output.
# Conditional expressions operate on one variable value and process the output
# based on the result of the conditional. An example conditional expression is
#
# <code>
#   {if id == 1}
#     <h1>The ID is {id}
#   {/if}
# </code>
#
# Conditional expressions in CCML follow the same format as ExpressionEngine
# with one difference. ExpressionEngine uses 'elseif' but Ruby uses 'elsif'.
# CCML supports both syntaxes so both
#
# <code>{if:elseif author}</code>
# 
# and
#
# <code>{if:elsif author}</code>
#
# are legal.
#
# For more information on ExpressionEngine conditional processing see
# http://expressionengine.com/user_guide/templates/globals/conditionals.html
#
# NOTE: CCML conditionals are processed using Ruby's 'eval' method so the
# conditional itself should work with any valid Ruby statement. Your mileage
# may very so test thoroughly if you get fancy.
#
# === Date and Time Formatting
#
# CCML tag pair variables support ExpressionEngine-style date and time formatting.
# Any variable within a tag pair may include a 'format' option. The value of the
# 'format' option is a Ruby date/time format string. When the 'format' option is
# present the parser will assume the value of the variable is a valid Ruby date
# or time object and will format it according to the provided format string.
# Formatting occurs at the final substitution, well after conditional processing
# has occurred. Subsequently, conditional expressions operate on the raw
# date/time value, not the formatted value.
#
# An example of a formatted date variable is:
#
# <code>{created_at format="%m-%d-%Y %I:%M %p"}</code>
#
# For more infotmation on ExpressionEngine date/time formatting see
# http://expressionengine.com/user_guide/templates/date_variable_formatting.html
#
# For more information on Ruby date/time formatting see
# http://www.ruby-doc.org/core/classes/Time.html#M000392
#
# === ActiveRecord Associations
#
# CCML tag pairs are ActiveRecord aware and will process tag variables through
# singular associations. Subsequently, the following variable is legal and will
# work as expected:
#
# <code>{author.name}</code>
#
# CCML tag variable processing only supports singular associations. It will not
# work if the association is a collection.
#++

module CCML

  SINGLE_TAG_PATTERN = /\{ccml:(?<class>\w+)(:(?<method>\w+))?(?<opts>[^\{}]*)?}/
  TAG_PAIR_PATTERN = /\{ccml:(?<class>\w+)(:(?<method>\w+))?(?<opts>[^}]*)?}(?<tag_body>.*?)\{\/ccml:\k<class>(:(?<close_method>\k<method>))?}/m
  INVALID_TAGS_PATTERN = /(\{ccml)|(\{\/ccml)/

  OPTIONS_PATTERN = /\s+(\w+)=("([^"]*)"|'([^']*)')/
    
  ILLEGAL_TAGS = ['base', 'single_tag', 'tag_pair']

  def CCML.parse(ccml, url = nil)

    # die if ccml data is not a string
    if not ccml.is_a?(String)
      raise CCML::Error::TemplateError, "CCML data is not a string."
    end

    # find and process tag pairs
    ccml = CCML.parse_tag_pairs(ccml, url)

    # find and process single tags
    ccml = CCML.parse_single_tags(ccml, url)

    # find malformed tags and abend
    if ccml =~ INVALID_TAGS_PATTERN
      raise CCML::Error::TemplateError, "Template contains invalid CCML tags."
    end

    return ccml
  end

  private

  def CCML.instanciate_tag(clazz, url, opts = {})
    if ILLEGAL_TAGS.include?(clazz)
      raise CCML::Error::TagBaseClassInTemplateError
    end
    begin
      clazz = "CCML::Tag::#{clazz.classify}Tag"
      tag = clazz.constantize.new(opts, url)
    rescue
      raise CCML::Error::TagClassNotFoundError, "Unable to initialize object for '#{clazz}' tag."
    end
    return tag
  end

  def CCML.run_tag_method(tag, method)
    begin
      sub = tag.send(method.to_sym)
    rescue
      raise CCML::Error::TagMethodNotFoundError, "Unable to find method '#{method}' of '#{tag.class}' object."
    end
    return sub
  end

  def CCML.parse_options(match)
    opts = {}
    if not match[:opts].blank?
      options = match[:opts].scan(OPTIONS_PATTERN)
      options.each do |opt|
        opt.pop if opt.last.nil?
        opts[opt.first.to_sym] = opt.last
      end
    end
    return opts
  end

  def CCML.parse_opening_tag(match)
    clazz = match[:class]
    method = ( match[:method].nil? ? 'index' : match[:method] )
    opts = CCML.parse_options(match)
    return clazz, method, opts
  end

  def CCML.parse_tag_pairs(ccml, url)

    # find the first match
    match = TAG_PAIR_PATTERN.match(ccml)

    # iterate until no more matches exist
    while not match.nil?

      # check for matching open/close method
      if match[:method] != match[:close_method]
        raise CCML::Error::TemplateError, "Open tag '#{match[:method]}' method does not match close tag '#{match[:close_method]}' method."
      end

      # get the data from the matching string
      clazz, method, opts = CCML.parse_opening_tag(match)

      # create an instance of the tag class and set tag data
      tag = CCML.instanciate_tag(clazz, url, opts)
      tag.tag_body = match[:tag_body]

      # run the method and substitute the results into the ccml
      sub = CCML.run_tag_method(tag, method)
      ccml = ccml.sub(match.to_s, sub)

      # look for another match
      pos = match.begin(0) + sub.length
      match = TAG_PAIR_PATTERN.match(ccml, pos)
    end

    return ccml
  end

  def CCML.parse_single_tags(ccml, url)

    # find the first match
    match = SINGLE_TAG_PATTERN.match(ccml)

    # iterate until no more matches exist
    while not match.nil?

      # get the data from the matching string
      clazz, method, opts = CCML.parse_opening_tag(match)

      # create an instance of the tag class
      tag = CCML.instanciate_tag(clazz, url, opts)

      # run the method and substitute the results into the ccml
      sub = CCML.run_tag_method(tag, method)
      ccml = ccml.sub(match.to_s, sub)

      # look for another match
      pos = match.begin(0) + sub.length
      match = SINGLE_TAG_PATTERN.match(ccml, pos)
    end

    return ccml
  end

end

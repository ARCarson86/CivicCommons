require 'spec_helper'

describe ApplicationHelper do
  describe 'when displaying html' do

    it 'will remove script tags and their content' do
      html_example = 'This text is <script type="text/javascript">alert("hello");</script> bad.'
      sanitize(html_example).should == 'This text is  bad.'

      html_example = "This text is <script type='text/javascript'>alert('hello');</script> bad."
      sanitize(html_example).should == 'This text is  bad.'

      html_example = 'This text is <script>alert("hello");</script> bad.'
      sanitize(html_example).should == 'This text is  bad.'

      html_example = "This text is <script type=\"text/javascript\">\n\nalert('hello');\n</script> bad."
      sanitize(html_example).should == 'This text is  bad.'

      strip_tags("sdfasdf<<b>script>alert('hello')<</b>/script>").should == "sdfasdfalert('hello')"
      strip_links("<a xhref='http://www.holy-angel.com/'><a xhref='http://www.attacker.com/'>Test</a></a>").should == "Test"
    end

    it 'will remove style tags and their content' do
      html_example = 'This text is <style type="text/css">* { font-size: 10em; }</style>'
      sanitize(html_example).should == 'This text is '

      html_example = "This text is <style type=\"text/css\">*\n{\nfont-size: 10em;\n}</style>"
      sanitize(html_example).should == 'This text is '
    end

    it 'will wrap lines in paragraph tags' do
      html_example = '<a href="http://example.com/">Example</a>'
      sanitize(html_example).should == "<a href=\"http://example.com/\">Example</a>"
    end

    it 'will leave whitelisted HTML tags' do
      tags = ['b', 'strong', 'i', 'em', 'a', 'div', 'p']
      tags.each do |tag|
        html_example = "text is <#{tag}>cool</#{tag}>!"
        sanitize(html_example).should == html_example
      end
    end

    it 'will remove non-whitelisted HTML tags' do
      tags = ['table', 'tr', 'td', 'th', 'tbody', 'thead']
      tags.each do |tag|
        html_example = "text is <#{tag}>cool</#{tag}>!"
        sanitize(html_example).should == "text is cool!"
      end

      html_example = "<table><tr><td>text</td><td>is</td><td>cool</td></tr></table>"
      sanitize(html_example).should == 'textiscool'
    end
  end
end
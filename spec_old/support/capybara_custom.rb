module Capybara::Node::Actions
  
  # http://slightlytechnical.co.uk/2010/12/12/fill-in-date-and-time-selects-with-capybara
  # https://gist.github.com/558786
  def select_date(field, options = {})
    date     = Date.parse(options[:with])
    find(:xpath, "//select[contains(@id, \"#{field}_1i\")]").find(:xpath, ::XPath::HTML.option(date.year.to_s)).select_option
    find(:xpath, "//select[contains(@id, \"#{field}_2i\")]").find(:xpath, ::XPath::HTML.option(date.strftime('%B').to_s)).select_option
    find(:xpath, "//select[contains(@id, \"#{field}_3i\")]").find(:xpath, ::XPath::HTML.option(date.day.to_s)).select_option
  end

  def select_time(field, options = {})
    time     = Time.parse(options[:with])    
    find(:xpath, "//select[contains(@id, \"#{field}_4i\")]").find(:xpath, ::XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
    find(:xpath, "//select[contains(@id, \"#{field}_5i\")]").find(:xpath, ::XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
  end

  def select_datetime(field, options = {})
    select_date(field, options)
    select_time(field, options)
  end
end

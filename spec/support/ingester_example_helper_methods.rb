module IngesterExampleHelperMethods
  def expects_exception(options)
    exception_message = build_exception_message(options[:line_number],
                                                options[:message])
    lambda{
      Ingester.ingest(options[:script])
    }.should raise_error(Ingester::Error,
                         exception_message)
  end
  
  def build_exception_message(line_number, explanation)
    line_number.nil? ? "Error ingesting transcript; #{explanation}" :
      "Error ingesting transcript around line #{line_number}; #{explanation}"
  end

  def read_fixture(filename)
    File.read(File.join(Rails.root, "spec", "fixtures", "ingester", filename))
  end

end

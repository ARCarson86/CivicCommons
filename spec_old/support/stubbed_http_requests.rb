module StubbedHttpRequests
  def stub_contribution_urls
    stub_request(:get, /http:\/\/www\.example\.com.*/).to_return(:body => File.open("#{Rails.root}/spec/fixtures/example_link.html"), :status => 200)
    stub_request(:get, "http://www.example.com/this-page-does-not-exist").to_return(:status => 404)
    stub_request(:get, YouTubeable::YOUTUBE_REGEX).to_return(:body => File.open("#{Rails.root}/spec/fixtures/example_youtube.html"), :status => 200)
  end

  def stub_amazon_s3_request
    stub_request(:any, /s3\.amazonaws\.com.*/)
  end

  # This set can be used to mock Embedly calls, but the regex needs more work if we want to mock multiple requests
  def stub_pro_embedly_request
    stub_request(:get, /http:\/\/.*\.embed\.ly.*maps\.google\.com/).to_return(:body => File.open("#{Rails.root}/spec/fixtures/embedly/google_map.json"), :status => 200)
    stub_request(:get, /http:\/\/.*\.embed\.ly.*youtube\.com/).to_return(:body => File.open("#{Rails.root}/spec/fixtures/embedly/youtube.json"), :status => 200)
    stub_request(:get, /http:\/\/.*\.embed\.ly.*yahoo\.com/).to_return(:body => File.open("#{Rails.root}/spec/fixtures/embedly/youtube.json"), :status => 200)
    stub_request(:get, /http:\/\/.*\.embed\.ly.*example\.com/).to_return(:body => File.open("#{Rails.root}/spec/fixtures/embedly/youtube.json"), :status => 200)
  end

  def stub_gravatar
    stub_request(:get, /http:\/\/gravatar\.com\/avatar.*/).to_return(:body => '', :status => 404)
  end

end

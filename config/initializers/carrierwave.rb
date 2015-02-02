if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => S3Config.access_key_id,   # required
      :aws_secret_access_key  => S3Config.secret_access_key  # required
    }
    config.fog_directory  = S3Config.bucket                          # required
    config.fog_host       = "http://s3.amazonaws.com/#{S3Config.bucket}"# 'https://assets.example.com'  # optional, defaults to nil
  end
end

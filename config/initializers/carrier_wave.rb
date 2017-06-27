if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :region => ENV['us-east-1'],
      :aws_access_key_id     => ENV['AKIAJ3WIIQFLEGITLHJA'],
      :aws_secret_access_key => ENV['9eYAp2par7CXlp0H7KrQfE7WJ7CCGSsx3kT+ruhf']
    }
    config.fog_directory     =  ENV['dreamstarter-sample-app']
  end
end

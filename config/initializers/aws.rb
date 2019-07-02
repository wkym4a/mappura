ActionMailer::Base.add_delivery_method(
  :ses,
  AWS::SES::Base,
  access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
  secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
  server: 'email.us-west-2.amazonaws.com'
)

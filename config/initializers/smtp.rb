if Rails.env.staging? || Rails.env.production?
  SMTP_SETTINGS = {
    address: ENV.fetch('MAILGUN_SMTP_SERVER'), # example: 'smtp.sendgrid.net'
    authentication: :plain,
    domain: ENV.fetch('SMTP_DOMAIN'), # example: 'this-app.com'
    enable_starttls_auto: true,
    password: ENV.fetch('MAILGUN_SMTP_PASSWORD'),
    port: ENV.fetch('MAILGUN_SMTP_PORT'),
    user_name: ENV.fetch('MAILGUN_SMTP_LOGIN')
  }
end

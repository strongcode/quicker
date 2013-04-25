if Rails.env != "development"
  SnapGadget::Application.config.middleware.use ExceptionNotifier,
                                                   :email_prefix => "[#{configatron.site_name}] #{Rails.env.titleize} Error:",
                                                   :sender_address => %{"Notifier" <kbcpart1@gmail.com>},
                                                   :exception_recipients => configatron.developers.email
end
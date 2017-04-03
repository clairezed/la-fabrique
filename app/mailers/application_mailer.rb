# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: SYSTEM_MAILER
  layout 'mailer'
end

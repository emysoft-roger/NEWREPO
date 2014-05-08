# encoding: utf-8
# lib/devise_backgrounder.rb
# Mailer proxy to send devise emails in the background
class DeviseBackgrounder

  def self.confirmation_instructions(record, token, opts = {})
    new(:confirmation_instructions, record, token, opts)
  end

  def self.reset_password_instructions(record, token, opts = {})
    new(:reset_password_instructions, record, token, opts)
  end

  def self.unlock_instructions(record, token, opts = {})
    new(:unlock_instructions, record, token, opts)
  end

  def initialize(method, record, token, opts = {})
    @method, @record, @token, @opts = method, record, token, opts
  end

  def deliver
    # You need to hardcode the class of the Devise mailer that you
    # actually want to use. The default is Devise::Mailer.
    if Rails.env.production?
      Devise::Mailer.delay.send(@method, @record, @token, @opts)
    else
      Devise::Mailer.send(@method, @record, @token, @opts)
    end
  end
end

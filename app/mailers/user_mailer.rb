# encoding: utf-8
class UserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.

  def confirmation_instructions(record, token, opts = {})
    opts[:subject] = "[LouerUnSenior] Confirmation d'inscription #{record}"
    super
  end

end

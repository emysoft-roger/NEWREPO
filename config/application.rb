# encoding: utf-8
require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env)
module LouerunseniorRails
  class Application < Rails::Application
    config.assets.initialize_on_precompile = false
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.stylesheets     false
      g.jbuilder        false
      g.helper          false
      g.javascripts     false
    end
  end
end

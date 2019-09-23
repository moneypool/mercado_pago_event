$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "mercado_pago_event/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mercado_pago_event"
  spec.version     = MercadoPagoEvent::VERSION
  spec.authors     = ["Oscar Elizondo"]
  spec.email       = ["oscar@moneypool.mx"]
  spec.homepage    = "https://github.com/moneypool/mercado_pago_event"
  spec.summary     = "Webhook listener for MercadoPago"
  spec.description = "This engine listens for post messages/updates after a payment has been created in MercadoPago"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"
  spec.add_dependency "mercadopago-sdk"
  spec.add_dependency "rspec-rails"
  spec.add_development_dependency "byebug"
end

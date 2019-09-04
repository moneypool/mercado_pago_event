require 'rails'

require File.expand_path('../../lib/mercado_pago_event', __FILE__)
Dir[File.expand_path('../spec/support/**/*.rb', __FILE__)].each { |f| require f }


RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    MercadoPagoRuby = MercadoPago
  end

  config.before do
    @payment_retriever = MercadoPagoEvent.payment_retriever
    @notifier = MercadoPagoEvent.backend.notifier
    MercadoPagoEvent.backend.notifier = @notifier.class.new
  end
end

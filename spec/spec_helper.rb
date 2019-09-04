require File.expand_path('../../lib/mercado_pago_event', __FILE__)
require_relative "support/mercado_pago"

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

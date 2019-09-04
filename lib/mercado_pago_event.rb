require "active_support/notifications"
require "mercadopago.rb"
require "mercado_pago_event/engine" if defined?(Rails)

module MercadoPagoEvent
  NAMESPACE = "mercado_pago_event"

  class << self
    attr_accessor :adapter, :backend, :payment_retriever

    def configure(&block)
      raise ArgumentError, "must provide a block" unless block_given?
      block.arity.zero? ? instance_eval(&block) : yield(self)
    end

    def instrument(params)
      payment = payment_retriever.call(params[:data][:id])
      backend.instrument("#{NAMESPACE}.#{params[:action]}", payment)
    end

    def subscribe(name, callable = Proc.new)
      backend.subscribe "#{NAMESPACE}.#{name}", adapter.call(callable)
    end

    def listening?(name)
      namespaced_name = "#{NAMESPACE}.#{name}"
      backend.notifier.listening?(namespaced_name)
    end
  end

  class NotificationAdapter < Struct.new(:subscriber)
    def self.call(callable)
      new(callable)
    end

    def call(*args)
      payload = args.last
      subscriber.call(payload)
    end
  end

  self.adapter = NotificationAdapter
  self.backend = ActiveSupport::Notifications
  self.payment_retriever = lambda { |id| MercadoPagoRuby.get("/v1/payments/#{id}") }
end

# POST Example from Mercado Pago

# {
#     "id": 12345,
#     "live_mode": true,
#     "type": "payment",
#     "date_created": "2015-03-25T10:04:58.396-04:00",
#     "application_id": 123123123,
#     "user_id": 44444,
#     "version": 1,
#     "api_version": "v1",
#     "action": "payment.created",
#     "data": {
#         "id": "999999999"
#     }
# }

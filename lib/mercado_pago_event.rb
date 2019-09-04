require "active_support/notifications"
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

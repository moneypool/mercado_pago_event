module MercadoPagoEvent
  class WebhookController
    def event
      MercadoPagoEvent.instrument(params)
      head :ok
    end
  end
end

module MercadoPagoEvent
  class WebhookController < ActionController::Base
    def event
      MercadoPagoEvent.instrument(params)
      head :ok
    end
  end
end

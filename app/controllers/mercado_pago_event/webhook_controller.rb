module MercadoPagoEvent
  class WebhookController < ActionController::Base
    def event
      MercadoPagoEvent.instrument(permitted_params)
      head :ok
    end

    def permitted_params
      params.permit!
    end
  end
end

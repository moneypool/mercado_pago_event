module MercadoPagoEvent
  class WebhookController < ActionController::Base
    def event
      MercadoPagoEvent.instrument(permitted_params)
      head :ok
    end

    def permitted_params
      params.permit(:action, :api_version, :application_id, :date_created, :id, :live_mode, :type, :user_id, :data, :version, :webhook)
    end
  end
end

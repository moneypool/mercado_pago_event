# MercadoPagoEvent
Webhook listener for the MercadoPago API.

Based on [previously developed ConektaEvent](https://github.com/moneypool/conekta_event).

# Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mercado_pago_event'
```
## Configuration

```ruby
# config/routes.rb
mount MercadoPagoEvent::Engine, at: '/my-chosen-path' # provide a custom path
```

Make sure you have a MercadoPago instance in your app:

```ruby
# config/initializers/mercado_pago.rb
YourMercadoPago = MercadoPago.new(ENV["YOUR_ACCESS_TOKEN"])
```

## Waiting for hooks

Subscribe to MercadoPago's webhook events:

```ruby
MercadoPagoEvent.subscribe "payment.created" do
  MercadoPagoEvents.new(event).paid
end
```

You can find a list of Webhook events [here](https://www.mercadopago.com.mx/developers/es/guides/notifications/webhooks).

### Example POST from MercadoPago:

```
{
    "id": 12345,
    "live_mode": true,
    "type": "payment",
    "date_created": "2015-03-25T10:04:58.396-04:00",
    "application_id": 123123123,
    "user_id": 44444,
    "version": 1,
    "api_version": "v1",
    "action": "payment.created",
    "data": {
        "id": "999999999"
    }
}
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

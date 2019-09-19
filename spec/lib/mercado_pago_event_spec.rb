require "spec_helper"

describe MercadoPagoEvent do
  let(:events) { [] }
  let(:subscriber) { -> (event) { events << event } }
  let(:event) { {action: "payment.created", data: { id: '0000001' }} }

  describe ".configure" do
    it "is configured by a block" do
      yielded = nil
      MercadoPagoEvent.configure { |events| yielded = events }

      expect(yielded).to eq(MercadoPagoEvent)
    end

    it "requires a block argument" do
      expect { MercadoPagoEvent.configure }.to raise_error ArgumentError
    end
  end

  describe "subscribing to an event" do
    before do
      expect(MercadoPagoRuby).to receive(:get).with("/v1/payments/0000001").and_return(charge_succeeded)
    end

    context "with a block subscriber" do
      it "calls the subscriber with the event" do
        MercadoPagoEvent.subscribe("payment.created", &subscriber)
        MercadoPagoEvent.instrument(event)

        expect(events).to eq([charge_succeeded])
      end
    end

    context "with a subscriber that responds to call" do
      it "calls the subscriber with the event" do
        MercadoPagoEvent.subscribe("payment.created", subscriber)
        MercadoPagoEvent.instrument({action: "payment.created", data: { id: '0000001' }})

        expect(events).to eq([charge_succeeded])
      end
    end
  end

  describe ".listening?" do
    it "returns true when there is a subscriber for that event" do
      MercadoPagoEvent.subscribe('payment.created', &subscriber)

      expect(MercadoPagoEvent.listening?("payment.created")).to be true
    end

    it "returns false when there is a subscriber for that event" do
      MercadoPagoEvent.subscribe('payment.updated', &subscriber)

      expect(MercadoPagoEvent.listening?("payment.created")).to be false
    end
  end

  describe MercadoPagoEvent::NotificationAdapter do
    let(:adapter) { MercadoPagoEvent.adapter }

    it "calls the subscriber with the last argument" do
      expect(subscriber).to receive(:call).with(:last)

      adapter.call(subscriber).call(:first, :last)
    end
  end

  private

  def charge_succeeded
    OpenStruct.new(id: '0000001', status: 'approved')
  end
end

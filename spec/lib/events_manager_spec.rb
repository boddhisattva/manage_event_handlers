describe EventsManager do
  describe "#subscribe" do
    context "argument to subscribe to is nil" do
      it "does not store nil handler values" do
        events_manager = EventsManager.new
        add_nums = nil

        events_manager.subscribe(add_nums)

        expect(events_manager.subscribers).to be_empty
      end
    end

    context "given a block to subscribe to" do
      it "stores the block as a handler" do
        events_manager = EventsManager.new
        add_nums = lambda { |a, b| a + b }

        events_manager.subscribe(add_nums)

        expect(events_manager.subscribers.first).to eq(add_nums)
      end
    end
  end
end

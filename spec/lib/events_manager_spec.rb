describe EventsManager do
  describe "#subscribe" do
    context "event name is nil" do
      it "raises Argument Error" do
        events_manager = EventsManager.new
        event_name = nil

        expect { events_manager.subscribe(event_name) do |name|
          puts "Hello #{name}"
        end }.to raise_error(ArgumentError)
      end
    end

    context "block is not passed" do
      it "raises Argument Error" do
        events_manager = EventsManager.new
        add_nums = :add_numbers

        expect { events_manager.subscribe(add_nums) }.to raise_error(ArgumentError)
      end
    end

    context "given a block to subscribe to" do
      it "stores the block as a handler" do
        events_manager = EventsManager.new

        events_manager.subscribe(:add_numbers) do |a, b|
          a + b
        end

        expect(events_manager.subscribers).not_to be_empty
      end
    end
  end
end

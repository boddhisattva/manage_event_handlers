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

  describe "#broadcast" do
    context "given an event name and an arbitrary number of arguments" do
      context "event name exists among list of subscriber events" do
        it "each subscriber listening to the event initiates a listener call" do
          events_manager = EventsManager.new

          events_manager.subscribe(:add_numbers) do |a, b|
            a + b
          end

          events_manager.subscribe(:add_numbers) do |*a|
            a.sum
          end

          expect(events_manager.subscribers.first).to receive(:initiate_listener_call).once
          expect(events_manager.subscribers.to_a.last).to receive(:initiate_listener_call).once

          events_manager.broadcast(:add_numbers, 4, 5)
        end
      end

      context "event name does not exist among list of subscriber events" do
        it "none of the one or many subscribers initiate a listener call" do
          events_manager = EventsManager.new

          events_manager.subscribe(:add_numbers) do |a, b|
            a + b
          end

          expect(events_manager.subscribers.first).not_to receive(:initiate_listener_call)

          events_manager.broadcast(:add_nums, 4, 5)
        end
      end
    end
  end
end

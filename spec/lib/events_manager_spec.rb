describe EventsManager do
  let(:events_manager) { EventsManager.new }

  describe "#subscribe" do
    context "event name is nil" do
      it "raises Argument Error with an appropriate error message" do
        expect { events_manager.subscribe(nil) do |name|
          puts "Hello #{name}"
        end }.to raise_error(ArgumentError, 'An event name needs to be specified')
      end
    end

    context "block is not passed" do
      it "raises Argument Error with an appropriate error message" do
        expect { events_manager.subscribe(:add_numbers) }.to raise_error(ArgumentError, 'A block needs to be passed')
      end
    end

    context "given a block to subscribe to" do
      it "stores the block as a handler" do
        expect { events_manager.subscribe(:add_numbers) do |a, b|
          a + b
        end }.to change{ events_manager.subscribers.count }.from(0).to(1)
      end

      context "same handler(i.e., event name and block) is passed multiple times" do
        it "raises Duplicate Handler error" do
          add_numbers = lambda { |a, b| a + b }
          message = 'An event handler comprising of an event name and a block can only be subscribed to once at a given point in time'

          events_manager.subscribe(:add_numbers, &add_numbers)

          expect { events_manager.subscribe(:add_numbers, &add_numbers) }.to raise_error(DuplicateHandlerError, message)
        end
      end
    end
  end

  describe "#unsubscribe" do
    context 'given a block' do
      context 'block exists among list of subscribers' do
        it 'removes it from the list of handlers and reduces the count of subscribers by 1' do
          add_nums = lambda { |a, b| a + b }

          events_manager.subscribe(:add_numbers, &add_nums)
          events_manager.subscribe(:subtract_numbers) do |a, b|
            a - b
          end

          allow(events_manager.subscribers).to receive(:detect) { events_manager.subscribers.first }

          expect { events_manager.unsubscribe(&add_nums) }.to change{ events_manager.subscribers.count }.from(2).to(1)
        end
      end

      context 'block does not exists among list of subscribers' do
        it 'the list of handlers and the count of total subscribers remain the same' do
          add_nums = lambda { |a, b| a + b }
          add_numbers = lambda { |a, b| a + b }

          events_manager.subscribe(:add_numbers, &add_numbers)
          events_manager.subscribe(:add_nos) do |*a|
            a.sum
          end

          allow(events_manager.subscribers).to receive(:detect) { nil }

          expect { events_manager.unsubscribe(&add_nums) }.to_not change{ events_manager.subscribers.count }
        end
      end

    end

    context 'block is nil' do
      it 'raises an Argument Error' do
        empty_block = nil

        expect { events_manager.unsubscribe(&empty_block) }.to raise_error(ArgumentError, 'A block needs to be passed')
      end
    end
  end

  describe "#broadcast" do
    context "given an event name and an arbitrary number of arguments" do
      context "event name exists among list of subscriber events" do
        it "each subscriber listening to the event initiates a listener call" do
          events_manager.subscribe(:add_numbers) do |a, b|
            a + b
          end

          events_manager.subscribe(:add_numbers) do |*a|
            a.sum
          end

          last_subscriber = events_manager.subscribers.to_a.last

          allow(events_manager.subscribers.first).to receive(:listening_on?) { true }
          allow(last_subscriber).to receive(:listening_on?) { true }

          expect(events_manager.subscribers.first).to receive(:initiate_listener_call).once
          expect(last_subscriber).to receive(:initiate_listener_call).once

          events_manager.broadcast(:add_numbers, 4, 5)
        end
      end

      context "event name does not exist among list of subscriber events" do
        it "none of the one or many subscribers initiate a listener call" do
          events_manager.subscribe(:add_numbers) do |a, b|
            a + b
          end

          allow(events_manager.subscribers.first).to receive(:listening_on?) { false }

          expect(events_manager.subscribers.first).not_to receive(:initiate_listener_call)

          events_manager.broadcast(:add_nums, 4, 5)
        end
      end

      context "event name is not passed" do
        it "raises Argument Error with an appropriate error message" do
          expect { events_manager.broadcast(nil, "Ronnie", "Bo") }.to raise_error(ArgumentError, 'An event name needs to be specified')
        end
      end
    end
  end
end

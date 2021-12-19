describe Event do
  describe "#listening_on?" do
    context "Given event name exists among list of existing events" do
      it "returns true" do
        add_nums = lambda { |a, b| a + b }

        event = Event.new(:add_numbers, add_nums)

        expect(event.listening_on?(:add_numbers)).to be true
      end
    end

    context "Given event name does not exist among list of existing events" do
      it "returns false" do
        add_nums = lambda { |a, b| a + b }

        event = Event.new(:add_numbers, add_nums)

        expect(event.listening_on?(:add_nos)).to be false
      end
    end

    context "event name is nil" do
      it "raises Argument Error with an appropriate error message" do
        add_nums = lambda { |a, b| a + b }
        event = Event.new(:add_numbers, add_nums)
        event_name = nil

        expect { event.listening_on?(event_name) }.to raise_error(ArgumentError, 'An event name needs to be specified')
      end
    end
  end

  describe "#has_matching_listener?" do
    context "Given event block exists among list of existing events" do
      it "returns true" do
        add_nums = lambda { |a, b| a + b }

        event = Event.new(:add_numbers, add_nums)

        expect(event.has_matching_listener?(&add_nums)).to be true

      end
    end

    context "Given event block does not exists among list of existing events" do
      it "returns false" do
        add_nums = lambda { |a, b| a + b }
        add_nos = lambda { |*a| a.sum }

        event = Event.new(:add_numbers, add_nums)

        expect(event.has_matching_listener?(&add_nos)).to be false
      end
    end

    context 'block is nil' do
      it 'raises an Argument Error with an appropriate error message' do
        add_nums = lambda { |a, b| a + b }
        event = Event.new(:add_numbers, add_nums)
        empty_block = nil

        expect { event.has_matching_listener?(&empty_block) }.to raise_error(ArgumentError, 'A block needs to be passed')
      end
    end
  end

  describe "#initiate_listener_call" do
    context "given one or more arguments" do
      it "executes the event listener" do
        add_nos = lambda { |*a| a.sum }

        event = Event.new(:add_numbers, add_nos)

        expect(event.initiate_listener_call(2, 5, 2)).to eq 9

      end
    end
  end
end

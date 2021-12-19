describe Event do
  let(:add_nums) { ->(a, b) { a + b } }
  let(:event) { Event.new(:add_numbers, add_nums) }

  describe '#listening_on?' do
    context 'Given event name exists among list of existing events' do
      it 'returns true' do
        expect(event.listening_on?(:add_numbers)).to be true
      end
    end

    context 'Given event name does not exist among list of existing events' do
      it 'returns false' do
        expect(event.listening_on?(:add_nos)).to be false
      end
    end

    context 'event name is nil' do
      it 'raises Argument Error with an appropriate error message' do
        expect { event.listening_on?(nil) }.to raise_error(ArgumentError, 'An event name needs to be specified')
      end
    end
  end

  describe '#has_matching_listener?' do
    context 'Given event block exists among list of existing events' do
      it 'returns true' do
        expect(event.has_matching_listener?(&add_nums)).to be true
      end
    end

    context 'Given event block does not exists among list of existing events' do
      it 'returns false' do
        add_nos = ->(*a) { a.sum }

        expect(event.has_matching_listener?(&add_nos)).to be false
      end
    end

    context 'block is nil' do
      it 'raises an Argument Error with an appropriate error message' do
        empty_block = nil

        expect do
          event.has_matching_listener?(&empty_block)
        end.to raise_error(ArgumentError, 'A block needs to be passed')
      end
    end
  end

  describe '#initiate_listener_call' do
    let(:add_nums) { ->(*a) { a.sum } }
    context 'given one or more arguments' do
      it 'executes the event listener' do
        expect(event.initiate_listener_call(2, 5, 2)).to eq 9
      end
    end
  end
end

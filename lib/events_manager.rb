class EventsManager
  attr_accessor :subscribers

  def initialize
    @subscribers = Set.new
  end

  def subscribe(event_name, &block)
    raise ArgumentError if event_name.nil? || !block
    subscribers << Event.new(event_name, block)
  end

  def broadcast(event_name, *args)
    subscribers.each do |subscriber|
      subscriber.initiate_listener_call(*args) if subscriber.listening_on?(event_name)
    end
  end
end

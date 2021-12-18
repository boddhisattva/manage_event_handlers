class EventsManager
  attr_accessor :subscribers

  def initialize
    @subscribers = Set.new
  end

  def subscribe(event_name, &block)
    raise ArgumentError if event_name.nil? || !block

    subscribers << Event.new(event_name, block)
  end

  def unsubscribe(&block)
    raise ArgumentError if !block

    matched_subscriber = subscribers.detect { |subscriber| subscriber.has_matching_listener?(block) }
    subscribers.delete(matched_subscriber) if matched_subscriber
  end

  def broadcast(event_name, *args)
    raise ArgumentError if event_name.nil?

    subscribers.each do |subscriber|
      subscriber.initiate_listener_call(*args) if subscriber.listening_on?(event_name)
    end
  end
end

class DuplicateHandlerError < StandardError; end

class EventsManager
  attr_accessor :subscribers

  def initialize
    @subscribers = Set.new
  end

  def subscribe(event_name, &block)
    raise ArgumentError if event_name.nil? || !block

    if event_handler_not_already_present?(event_name, &block)
      subscribers << Event.new(event_name, block)
    else
      message = 'An event handler comprising of an event name and a block can only be subscribed to once at a given point in time'
      raise DuplicateHandlerError, message
    end
  end

  def unsubscribe(&block)
    raise ArgumentError if !block

    matched_subscriber = subscribers.detect { |subscriber| subscriber.has_matching_listener?(&block) }
    subscribers.delete(matched_subscriber) if matched_subscriber
  end

  def broadcast(event_name, *args)
    raise ArgumentError if event_name.nil?

    subscribers.each do |subscriber|
      subscriber.initiate_listener_call(*args) if subscriber.listening_on?(event_name)
    end
  end

  def event_handler_not_already_present?(event_name, &block)
    !subscribers.any? do |subscriber|
      subscriber.listening_on?(event_name) && subscriber.has_matching_listener?(&block)
    end
  end
end

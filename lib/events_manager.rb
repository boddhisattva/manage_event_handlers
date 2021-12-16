class EventsManager
  def initialize
    @subscribers = Set.new
  end

  def subscribe(event_name, &block)
    raise ArgumentError if event_name.nil? || !block
    subscribers << Event.new(event_name, block)
  end

  attr_accessor :subscribers
end

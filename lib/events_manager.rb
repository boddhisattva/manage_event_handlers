class EventsManager
  def initialize
    @subscribers = []
  end

  def subscribe(subscriber)
    subscribers << subscriber unless subscriber.nil?
  end

  attr_accessor :subscribers
end



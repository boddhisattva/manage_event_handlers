class Event
  def initialize(name, listener)
    @name = name
    @listener = listener
  end

  def listening_on?(event_name)
    event_name == name
  end

  def has_matching_listener?(&block)
    listener == block
  end

  def initiate_listener_call(*args)
    listener.call(*args)
  end

  private
    attr_reader :name, :listener
end

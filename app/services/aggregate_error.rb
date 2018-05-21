class AggregateError
  attr_accessor :errors
  def initialize(objects: [])
    @objects = objects.compact
    @errors = collect_errors
  end

  def collect_errors
    @objects
      .map { |obj| collect_messages(obj) }
      .flatten
  end

  def collect_messages(obj)
    obj.errors.full_messages
      .map { |message| PersonPresenter.formatted_error(message) }
      .reject { |message| message.empty? }
      .flatten
  end
end
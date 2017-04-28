class Api::Collections::Events < Api::Collections::Collection
  def events
    @resources
  end

  def events=(events)
    @resources = events
  end
end

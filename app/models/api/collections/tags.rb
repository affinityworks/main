class Api::Collections::Tags < Api::Collections::Collection
  def tags
    @resources
  end

  def tags=(tags)
    @resources = tags
  end
end

class Api::Collections::People < Api::Collections::Collection
  def people
    @resources
  end

  def people=(people)
    @resources = people
  end
end

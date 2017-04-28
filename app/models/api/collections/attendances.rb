class Api::Collections::Attendances < Api::Collections::Collection
  def attendances
    @resources
  end

  def attendances=(attendances)
    @resources = attendances
  end
end

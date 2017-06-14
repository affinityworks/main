class Api::Collections::Taggings < Api::Collections::Collection
  def taggings
    @resources
  end

  def taggings=(taggings)
    @resources = taggings
  end
end

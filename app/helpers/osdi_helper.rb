module OsdiHelper
  def osdi_identifier(model)
    "osdi:#{ActiveModel::Naming.singular(model)}-#{model.id}"
  end
end

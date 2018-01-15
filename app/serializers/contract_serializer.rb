class ContractSerializer < ActiveModel::Serializer
  attributes :id, :vendor, :starts_on, :ends_on,
    :price, :created_at, :updated_at

  def starts_on
    object.starts_on.to_s(:db)
  end

  def ends_on
    object.ends_on.to_s(:db)
  end
end

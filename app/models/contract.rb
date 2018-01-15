class Contract < ApplicationRecord
  attribute :price, :money

  belongs_to :user

  validates :vendor, :starts_on, :ends_on, :user_id, presence: true
  validates_each :ends_on do |record, attr, value|
    if record.starts_on.present? &&
      record.ends_on.present? &&
        record.ends_on.utc < record.starts_on.utc

      record.errors.add(attr, :greater_than, count: "Starts on" )
    end
  end
end

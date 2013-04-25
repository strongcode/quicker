class TrackersValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    user_ids = value.reject { |id| id.blank? }
    record.errors[attribute] << "Friends list cannot be empty." if user_ids.blank?
  end
end
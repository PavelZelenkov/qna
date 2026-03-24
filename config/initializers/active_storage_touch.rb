Rails.application.config.to_prepare do
  ActiveStorage::Attachment.class_eval do
    after_save :touch_record
    after_destroy :touch_record

    def touch_record
      record.touch if record
    end
  end
end

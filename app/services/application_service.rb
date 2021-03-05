module ApplicationService
  def return_message(success, payload = {})
    OpenStruct.new({ success?: success, payload: payload })
  end

  def log_errors(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")
    return_message(false, {})
  end
end

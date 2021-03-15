class ProcessContactFileJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(headers, contact_file_id)
    contact_file = ContactFile.where(id: contact_file_id).take
    ::ManageContactsCsv.new(
      {
        headers: headers,
        contact_file: contact_file
      }
    ).call
  end
end

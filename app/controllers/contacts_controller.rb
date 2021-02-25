class ContactsController < ApplicationController
  
  def index
  end

  def manage_csv
    if params["upload_csv"].nil?
      redirect_to contacts_path
    else
      file_path = params["upload_csv"]["file"].try(:path)
      filename = params["upload_csv"]["file"].try(:original_filename)
      # result = ::ManageContactsCsv.new({file_path: file_path, user: current_user, filename: filename}).call
      result = ::ManageContactsCsv.new({file_path: file_path, user: nil, filename: filename}).call
      if result.success?
        redirect_to contacts_path, notice: "File loaded successfully"
      else
        redirect_to contacts_path, alert: "#{result.payload[:error]}"
      end
    end
    
  end

end
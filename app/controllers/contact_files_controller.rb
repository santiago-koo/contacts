class ContactFilesController < ApplicationController

  def index
    @table_headers = %w{name status original_headers actions}
    @contact_files = current_user.contact_files
  end

  def new
  end

  def upload

    if params["upload_csv"].nil?
      redirect_to contact_files_path
    else
      file_path = params["upload_csv"]["file"].try(:path)
      filename = params["upload_csv"]["file"].try(:original_filename)
      result = ::ManageContactFile.new({file_path: file_path, user: current_user, filename: filename}).call
      if result.success?
        redirect_to contact_files_path, notice: "File loaded successfully"
      else
        redirect_to contact_files_path, alert: "#{result.payload[:error]}"
      end
    end

  end

end
class ContactFilesController < ApplicationController
  before_action :contact_file, except: %i[index new create]

  def index
    @pagy, @contact_files = pagy(current_user.contact_files.order(created_at: :desc), items: 10)
  end

  def show
    if @contact_file.on_hold?
      redirect_to contact_files_path
    else
      @pagy, @contacts = pagy(@contact_file.contacts.order(:created_at), items: 5)
    end
  end

  def new
    @contact_file = ContactFile.new
  end

  def create
    if params[:contact_file].present?
      file_path = params[:contact_file][:file].try(:path)
      filename = params[:contact_file][:file].try(:original_filename)
      result = ::ManageContactFile.new({ file_path: file_path, user: current_user, filename: filename }).call
      if result.success?
        redirect_to contact_files_path, notice: 'File loaded successfully'
      else
        redirect_to contact_files_path, alert: result.payload[:error]
      end
    else
      redirect_to contact_files_path
    end
  end

  def failed_contacts
    @pagy, @failed_contacts = pagy(@contact_file.failed_contacts.order(:created_at), items: 5)
  end

  def open_modal
    respond_to do |format|
      format.js
    end
  end

  def process_csv
    ::ProcessContactFileJob.perform_later(
      process_csv_params.to_h,
      @contact_file.id
    )

    redirect_to root_path, notice: 'CSV file is being processed. Lay on your couch and take an orange juice'
  end

  private

  def contact_file
    @contact_file = current_user.contact_files.where(id: params[:id]).take || not_found
  end

  def process_csv_params
    params.require(:process_csv).permit(:email, :name, :birth_date, :phone_number, :address, :credit_card)
  end
end

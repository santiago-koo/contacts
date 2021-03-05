class ContactFilesController < ApplicationController
  before_action :contact_file, except: %i[index new create]
  before_action :get_table_headers, only: %i[open_modal show failed_contacts]

  def index
    @table_headers = %w[name status original_headers created_at actions]
    @contact_files = current_user.contact_files.order(created_at: :desc)
  end

  def show
    @pagy, @contacts = pagy(@contact_file.contacts.order(:created_at), items: 5)
  end

  def new
    @contact_file = ContactFile.new
  end

  def create
    if params[:contact_file].nil?
      redirect_to contact_files_path
    else
      file_path = params[:contact_file][:file].try(:path)
      filename = params[:contact_file][:file].try(:original_filename)
      result = ::ManageContactFile.new({ file_path: file_path, user: current_user, filename: filename }).call
      if result.success?
        redirect_to contact_files_path, notice: 'File loaded successfully'
      else
        redirect_to contact_files_path, alert: result.payload[:error]
      end
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
    result = ::ManageContactsCsv.new(
      {
        headers: process_csv_params,
        contact_file: @contact_file
      }
    ).call
    if result.success?
      redirect_to root_path, notice: 'CSV file processed successfully'
    else
      redirect_to root_path, alert: result.payload[:error]
    end
  end

  private

  def contact_file
    @contact_file = current_user.contact_files.where(id: params[:id]).take || not_found
  end

  def get_table_headers
    @modal_table_headers = %w[email name birth_date phone_number address credit_card]
    @show_table_headers = %w[email name birth_date phone_number address franchise last_four_credit_card_numbers created_at]
  end

  def process_csv_params
    params.require(:process_csv).permit(:email, :name, :birth_date, :phone_number, :address, :credit_card)
  end
end

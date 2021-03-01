class ContactsController < ApplicationController
  
  before_action :get_contact_file, only: [:open_modal, :process_csv]
  before_action :get_table_headers, only: [:open_modal, :show]

  def index
  end

  def show
    @contacts = Contact.where(contact_file: params[:id])
  end

  def open_modal
    respond_to do |format|
      format.js
    end
  end

  def process_csv
    result = ::ManageContactsCsv.new({headers: process_csv_params.to_h, contact_file: @contact_file, user: current_user}).call()
    if result.success?
      redirect_to root_path, notice: "Csv file processed successfully"
    else
      redirect_to root_path
    end
  end

  private

  def get_contact_file
    @contact_file = ContactFile.where(id: params[:id]).last
  end

  def get_table_headers
    @table_headers = %w{email name birth_date phone_number address credit_card}
  end

  def process_csv_params
    params.require(:process_csv).permit(:email, :name, :birth_date, :phone_number, :address, :credit_card)
  end

end
require 'rails_helper'

RSpec.describe FailedContact, type: :model do

  it { should belong_to :contact_file }

end

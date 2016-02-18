require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:attachment) { create(:attachment) }

  it { should belong_to(:attachable) }

  it 'should method file_name returns name of file' do
    expect(attachment.file_name).to eq 'spec_helper.rb'
  end
end

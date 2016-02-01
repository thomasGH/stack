require 'rails_helper'

RSpec.describe CalculateReputationJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calculates reputation' do
    expect(Reputation).to recive(:calculate).with(answer)
    CalculateReputationJob
  end
end

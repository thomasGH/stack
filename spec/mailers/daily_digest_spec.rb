require "rails_helper"

RSpec.describe DailyDigest, type: :mailer do
  describe "digest" do
    let(:user) { create :user }
    let(:mail) { DailyDigest.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("List of last day questions")
    end
  end
end

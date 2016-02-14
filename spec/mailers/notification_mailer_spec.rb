require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notification" do
    let(:user) { create :user }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.answer_notification(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Новый ответ на вопрос")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("дан новый ответ")
    end
  end
end
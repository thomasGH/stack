require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET /index" do
    context "unauthorized" do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'returns 401 status if request has not access token' do
        get api_v1_question_answers_path(question), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get api_v1_question_answers_path(question), format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)}
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_v1_question_answers_path(question), format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body created_at updated_at question_id user_id).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe "GET /show" do
    context "unauthorized" do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'returns 401' do
        get api_v1_question_answer_path(question, answer), format: :json
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)}
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get api_v1_question_answer_path(question, answer), format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns answer' do
        expect(response.body).to have_json_path('answer')
      end

      %w(id body attachments created_at updated_at question_id user_id).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      context 'attachments' do
        it 'included in amswer' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        %w(id created_at updated_at attachable_id attachable_type).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end

        it "contains file/url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file/url")
        end
      end
    end
  end
end
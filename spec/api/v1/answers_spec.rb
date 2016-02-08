require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET /index" do
    let(:access_token) { create(:access_token)}

    it_behaves_like "API Authenticable" do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      let(:method) { :get }
      let(:api_path) { api_v1_question_answers_path(question) }
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_v1_question_answers_path(question), format: :json, access_token: access_token.token }

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
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:access_token) { create(:access_token)}

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { api_v1_question_answer_path(question, answer) }
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get api_v1_question_answer_path(question, answer), format: :json, access_token: access_token.token }

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

  describe "POST /create" do
    let(:access_token) { create(:access_token)}

    it_behaves_like "API Authenticable" do
      let(:method) { :post }
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:options) { { answer: { body: "answer_rest_api" } } }
    end
  end
end
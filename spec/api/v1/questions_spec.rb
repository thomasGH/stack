require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do
    let(:access_token) { create(:access_token)}

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
           expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe "GET /show" do
    let(:access_token) { create(:access_token)}
    let!(:question) { create(:question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { api_v1_question_path(question) }
    end

    context 'authorized' do
      before { get api_v1_question_path(question), format: :json, access_token: access_token.token }

      it 'returns question' do
        expect(response.body).to have_json_path('question')
      end

      %w(id title body answers attachments created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      context 'attachments' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        %w(id created_at updated_at attachable_id attachable_type).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it "contains file/url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file/url")
        end
      end
    end
  end
end
